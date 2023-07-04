import json
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .serializers import *
from django.conf import settings
from django.db import connection
from django.db.models import Q
from operator import or_
from functools import reduce

import pprint
#프린트디버깅용
def dp(sql_result):
    print("###########디버깅시작")
    pprint.pprint(sql_result)
    print("#####디버깅종료")

def row2dict(row, descs):
    #쿼리문을 통해 얻은 row를 딕셔너리화해주는 함수
    column_names = [desc[0] for desc in descs]
    return dict(zip(column_names, row))

def find_instances_with_max_value(instances, filter_field)->list:
    max_value = float('-inf')  # 가장 작은 값으로 초기화
    selected_instances = []
    for instance in instances:
        field_value = getattr(instance, filter_field)  # 필드의 값 가져오기
        if field_value > max_value:
            max_value = field_value  # 최대값 갱신
            selected_instances = [instance]  # 새로운 최대값을 가진 모델 선택
        elif field_value == max_value:
            selected_instances.append(instance)
    return selected_instances

def get_instance_rank(instance, filter_field):
    queryset = instance.__class__.objects.all().order_by(filter_field)
    rank = list(queryset).index(instance) + 1
    return rank

class IndustryAPIView(APIView):
    def get(self, request):
        with connection.cursor() as cursor:
            sql = "SELECT * FROM INDUSTRY"
            cursor.execute(sql)
            data = cursor.fetchall()

        serializer_data = [
            {
                'industry_id': row[0],
                # 다른 필드들에 대해서도 필요한 대로 매핑
                'industry': row[1]
            }
            for row in data
        ]

        serializer = IndustrySerializer(serializer_data, many=True)
        return Response(serializer.data)

@api_view(["GET"])
def test(request):
    sus_id = SustainReport.objects.filter(company_id = 10).values_list("sustain_report_id", flat=True).first()
    dp(sus_id)
    return Response()

@api_view(["POST"])
def oneOfPage(request):
    pprint.pprint(request.data)
    with connection.cursor() as cursor:
        sql = f"SELECT * FROM COMPANY"
        cursor.execute(sql)
        data:list[tuple] = cursor.fetchall()
        results = [list(row) for row in data]
        if request.method == "GET":
            #맨처음 서비스를 켰을때
            #재사용을 위해 json왔다 가정
            page:int = 1
            filter_score:str = "prism-ALL"
            filter_industries:list[str] = []
            filter_name:str = ""
        else:
            imported_data = request.data
            #사용자가 post보냈을 때
            #json해독
            page:int = imported_data["page"]
            filter_score:str = imported_data["filter_score"]
            filter_industries:list[str] = imported_data["filter_industries"]
            filter_name:str = imported_data["filter_name"]
        #이제부터 필터링
        #먼저 검색이름으로 필터링
        if filter_name != "":
            filtered_results = []
            for row in results:
                name = row[1]
                if filter_name in name:
                    filtered_results.append(row)
            results = filtered_results
        #그다음 업종으로 필터링
        cursor.execute(f"SELECT industry_id, industry FROM INDUSTRY")
        id2industry:dict = dict(cursor.fetchall())
        #업종이름, 업종id가 한 행으로 구성된 테이블 불러오기
        if len(filter_industries) != 0:
            cursor.execute(f"SELECT industry, industry_id FROM INDUSTRY")
            industry2id:dict = dict(cursor.fetchall())
            filtered_results = []
            for industry_str in filter_industries:
                industry_id = industry2id[industry_str]
                for row in results:
                    if row[2] == industry_id:
                        filtered_results.append(row)
            results = filtered_results
        #results에 해당하는 점수 붙이기
        for row in results:
            cursor.execute(f"SELECT {settings.JSON_TO_COL[filter_score]} FROM PRISM_SCORE WHERE company_id='{row[0]}'")
            #회사기준으로 점수를 찾고, 그중 가장 최신 점수를 result에 반영
            row.append(max(temp[0] for temp in cursor.fetchall()))
            #그다음 해당 회사를 평가한 esg기관들을 찾아냄 있으면 result에 반영
            institides = []
            for ins, kor_ins in (("KCGS_SCORE", "KCGS"), ("ESGLAB_SCORE", "한국ESG연구소")):
                cursor.execute(f"SELECT * FROM {ins} WHERE company_id={row[0]}")
                if cursor.fetchone() is not None:
                    #점수가 있다면
                    institides.append(kor_ins)
            row.append(institides)
    results = sorted(results, reverse=True ,key=lambda x: x[3])
    dp(results)
    NUM_ROW_OF_ONE_PAGE = 10
    pages_number = (len(results)-1)//NUM_ROW_OF_ONE_PAGE + 1
    #해당하는 모든 결과를 찾았으니, 그중에서 사용자가 원하는 페이지의 정보(최대 10)개로만 슬라이싱한다
    results = results[NUM_ROW_OF_ONE_PAGE*(page-1) : NUM_ROW_OF_ONE_PAGE*(page)]
    
    serializer_data = [
        {
            'name': row[1],
            'industry': id2industry[row[2]],
            'score': row[3],
            'esg_insts': row[4],
            'pages_number': pages_number,
        }
        for row in results
    ]
    serializer = oneOfPageSerializer(serializer_data, many=True)
    return Response(serializer.data)

@api_view(["POST"])
def yearsOfCompany(request):
    imported_data = request.data
    with connection.cursor() as cursor:
        try:
            company_name = imported_data["company"]
            sql = f"SELECT company_id FROM COMPANY WHERE company='{company_name}'"
            cursor.execute(sql)
            data = cursor.fetchone()
            company_id = data[0]
            sql = f"SELECT eval_year FROM PRISM_SCORE WHERE company_id={company_id}"
            cursor.execute(sql)
            data = cursor.fetchall()
            
            serializer_data = [{
                "years":[int(row[0]) for row in data]
            }]
            dp(serializer_data)
            serializer = yearsOfCompanySerializer(data=serializer_data, many = True)
            if serializer.is_valid() is False:
                raise ValueError("invalid serializer")
            dp(serializer.data)
            return Response(serializer.data)
        except:
            return Response("data not found", status=status.HTTP_404_NOT_FOUND)

@api_view(["POST"])
def oneOfCompany(request):
    imported_data = request.data
    exporting_data = [{}]
    #json해독
    with connection.cursor() as cursor:
        try:
            company_name = imported_data["company"]
        except:
            return Response("data is not regular. please obey the protocol." , status=status.HTTP_400_BAD_REQUEST)
        sql = f"SELECT * FROM COMPANY WHERE company='{company_name}'"
        cursor.execute(sql)
        data = cursor.fetchone()
        if data == None:
            return Response("This Company is not in DB", status=status.HTTP_400_BAD_REQUEST)
        company_id = data[0]
        company_industry = data[2]
        #company_name에 해당하는 prism_score에서 존재하는 년도 개수만큼
        sql = f"SELECT * FROM PRISM_SCORE WHERE company_id={company_id}"
        cursor.execute(sql)
        rows = cursor.fetchall()
        
        prisms = PrismScore.objects.filter(company_id = company_id).first()
        json_data = []
        #가져온 행을 딕셔너리화 함
        for row in rows:
            #sql = f"SELECT eval_year,overall_score,e_score,s_score,g_score,w_overall_score,w_e_score,w_s_score,w_g_score FROM PRISM_SCORE WHERE company_id={company_id}"
            sql = f"SELECT * FROM PRISM_SCORE WHERE company_id={company_id}"
            cursor.execute(sql)
            print("##@#",cursor.description)
            dict_row = row2dict(row, cursor.description)
            #prism랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                rank = get_instance_rank(prisms, rank_name+"_score")
                print(rank_name+"_rank", rank)
                dict_row[rank_name+"_rank"] = rank
            json_data.append(dict_row)
            #동업종간랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                sql = f"""SELECT ranking
FROM (
    SELECT RANK() OVER (ORDER BY P.{rank_name}_score DESC) AS ranking, CC.company, P.{rank_name}_score, P.eval_year
    FROM COMPANY CC
    JOIN PRISM_SCORE P ON CC.company_id = P.company_id
    WHERE P.eval_year = {dict_row["eval_year"]}
    AND CC.industry_id = (
        SELECT I.industry_id
        FROM COMPANY C
        JOIN INDUSTRY I ON C.industry_id = I.industry_id
        WHERE C.company = '{company_name}' -- 랭킹 보고 싶은 기업 이름 넣기
    )
) AS rankings
WHERE company = '{company_name}'; -- 랭킹 보고 싶은 기업 이름 넣기"""
                cursor.execute(sql)
                temp = cursor.fetchone()
                if temp == None:
                    rank = -1
                else:
                    rank = temp[0]
                print("ind_"+rank_name+"_rank", rank)
                dict_row["ind_"+rank_name+"_rank"] = rank
            json_data.append(dict_row)
            #Wprism랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                sql = f"""SELECT ranking, company, w_{rank_name}_score, eval_year
FROM (
   SELECT RANK() OVER (ORDER BY P.w_{rank_name}_score DESC) AS ranking, CC.company, P.w_{rank_name}_score, P.eval_year
   FROM COMPANY CC
   JOIN PRISM_SCORE P ON CC.company_id = P.company_id
   WHERE P.eval_year = {dict_row["eval_year"]}
    ) AS rankings
    WHERE company = '{company_name}';  -- 랭킹 보고 싶은 기업 이름 넣기"""
                cursor.execute(sql)
                temp = cursor.fetchone()
                if temp == None:
                    rank = -1
                else:
                    rank = temp[0]
                print("w_"+rank_name+"_rank", rank)
                dict_row["w_"+rank_name+"_rank"] = rank
            #프론트는 id가 필요없다!
            for delete in ["prism_score_id", "company_id"]:
                dict_row.pop(delete)
            json_data.append(dict_row)
        dp(json_data)
        serial_prism_score = OneCompanyPrismScoreSerializer(data = json_data, many = True)
        serial_prism_score.is_valid(raise_exception=True)
        exporting_data[0].update({"prism_scores" : serial_prism_score.data})
    
    prism_ind_avg_scores = PrismIndAvgScore.objects.filter(industry = company_industry)
    dp(prism_ind_avg_scores.values())
    serial_prism_ind_ave_scores = PrismIndAvgScoreSerializer(prism_ind_avg_scores, many=True)
    dp(serial_prism_ind_ave_scores.data)
    exporting_data[0].update({"prism_ind_avg_scores" : serial_prism_ind_ave_scores.data})

    kcgs_scores = KcgsScore.objects.filter(company_id =company_id)
    dp(kcgs_scores.values())
    serial_kcgs_scores = KcgsScoreSerializer(kcgs_scores, many=True)
    dp(serial_kcgs_scores.data)
    exporting_data[0].update({"kcgs_scores" : serial_kcgs_scores.data})

    esglab_scores = EsglabScore.objects.filter(company_id =company_id)
    dp(esglab_scores.values())
    serial_esglab_scores = EsglabScoreSerializer(esglab_scores, many=True)
    dp(serial_esglab_scores.data)
    exporting_data[0].update({"esglab_scores" : serial_esglab_scores.data})

    kcgs_ind_avg_scores = KcgsIndAvgScore.objects.filter(industry = company_industry)
    dp(kcgs_ind_avg_scores.values())
    serial_kcgs_ind_avg_scores = KcgsIndAvgScoreSerializer(kcgs_ind_avg_scores, many=True)
    dp(serial_kcgs_ind_avg_scores.data)
    exporting_data[0].update({"kcgs_ind_avg_scores" : serial_kcgs_ind_avg_scores.data})

    esglab_ind_avg_scores = EsglabIndAvgScore.objects.filter(industry = company_industry)
    dp(esglab_ind_avg_scores.values())
    serial_esglab_ind_avg_scores = EsglabIndAvgScoreSerializer(esglab_ind_avg_scores, many=True)
    dp(serial_esglab_ind_avg_scores.data)
    exporting_data[0].update({"esglab_ind_avg_scores" : serial_esglab_ind_avg_scores.data})

    sustain_reports = SustainReport.objects.filter(company_id =company_id)
    dp(sustain_reports.values())
    serial_sustain_reports = SustainReportSerializer(sustain_reports, many=True)
    dp(serial_sustain_reports.data)
    exporting_data[0].update({"sustain_reports" : serial_sustain_reports.data})

    #해당회사의 최신 연도에 해당하는 보고서에 적용된 GRI_INDEX 풀네임들을 가져와야함
    #company_id -> SUSTAIN_REPORT중에서 year가 가장 큰 모델의 id -> 여러개의 REPORT_TABLE을 찾음. 그 각자마다의 풀네임으로 변경
    suses = SustainReport.objects.filter(company_id = company_id)
    recent_suses =  find_instances_with_max_value(suses, "eval_year")
    #DB상 오류로 가장 최신이 여러개 일 수 있다.
    if len(recent_suses)>0:
        sustain_id = getattr(recent_suses[0], "sustain_report_id")
    else:
        sustain_id = None
    ret = None
    gri_indexes = []
    if sustain_id is not None:
        #최신년도 보고서가 있다면
        #최신년도 보고서에 해당하는 보고서테이블들
        ret = ReportTable.objects.filter(sustain_report_id = sustain_id)
        #최신년도 보고서에 해당하는 보고서문장들
        res = ReportSentences.objects.filter(sustain_report_id = sustain_id)
        #해당하는 테이블과 문장들 찾음 이제 각자마다 풀네임으로 바꿔줘야함
        gri_index_ids = []
        for re in res:
            gri_index_ids.append(getattr(re, "gri_index_id"))
        for re in ret:
            gri_index_ids.append(getattr(re, "gri_index_id"))
        gri_index_ids = list(set(gri_index_ids))
        for gri_index_id in gri_index_ids:
            gri_indexes.append(GriIndex.objects.filter(gri_index_id = gri_index_id).values_list("sub_num", flat=True).first())
    exporting_data[0].update({"gri_info" : gri_indexes})

    #report_sentences부분
    report_sentences = []
    for subres in list(res.values("gri_index","page_num","back_sentences","preced_sentences","most_sentences","sim_rank")):
        #subres는 {"gri_index" = 값, "page_num" = 값} 이런형태일것
        gri_index_id = subres["gri_index"]
        subres["gri_index"] = GriIndex.objects.filter(gri_index_id = gri_index_id).values_list("sub_num", flat=True).first()
        report_sentences.append(subres)
    exporting_data[0].update({"report_sentences" : report_sentences})

    #report_tables부분
    report_tables =[]
    for subret in list(ret.values("gri_index", "sim_rank", "html_code", "page_num")):
        #subres는 {"gri_index" = 값, "page" = 값} 이런형태일것
        gri_index_id = subret["gri_index"]
        subret["gri_index"] = GriIndex.objects.filter(gri_index_id = gri_index_id).values_list("sub_num", flat=True).first()
        report_tables.append(subret)
    exporting_data[0].update({"report_tables" : report_tables})
    
    return Response(exporting_data)

@api_view(["POST"])
def comparing(request):
    imported_data = request.data
    pprint.pprint(imported_data)
    exporting_data = [{}]
    industry_ids = []
    try:
        gri_indexes:list[int] = []
        list_of_year_companyname:list[str] = imported_data["reports"]
    except:
        Response("F->B KeyError!", status=status.HTTP_400_BAD_REQUEST)
    with connection.cursor() as cursor:
        for year_companyname in list_of_year_companyname:
            year, company_name = year_companyname.strip().split("_")
            print(company_name)
            sql = f"SELECT * FROM COMPANY WHERE company='{company_name}'"
            cursor.execute(sql)
            data = cursor.fetchone()
            if data == None:
                return Response("This Company is not in DB", status=status.HTTP_400_BAD_REQUEST)
            company_id = data[0]
            industry_ids.append(data[2])
        sql = f"SELECT * FROM COMPANY WHERE company='{company_name}'"
        cursor.execute(sql)
        data = cursor.fetchone()
        if data == None:
            return Response("This Company is not in DB", status=status.HTTP_400_BAD_REQUEST)
        company_id = data[0]
        company_industry = data[2]
        #company_name에 해당하는 prism_score에서 존재하는 년도 개수만큼
        sql = f"SELECT * FROM PRISM_SCORE WHERE company_id={company_id}"
        cursor.execute(sql)
        rows = cursor.fetchall()
    
        prisms = PrismScore.objects.filter(company_id = company_id).first()
        json_data = []
        #가져온 행을 딕셔너리화 함
        for row in rows:
            #sql = f"SELECT eval_year,overall_score,e_score,s_score,g_score,w_overall_score,w_e_score,w_s_score,w_g_score FROM PRISM_SCORE WHERE company_id={company_id}"
            sql = f"SELECT * FROM PRISM_SCORE WHERE company_id={company_id}"
            cursor.execute(sql)
            print("##@#",cursor.description)
            dict_row = row2dict(row, cursor.description)
            #prism랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                rank = get_instance_rank(prisms, rank_name+"_score")
                print(rank_name+"_rank", rank)
                dict_row[rank_name+"_rank"] = rank
            #json_data.append(dict_row)
            #동업종간랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                sql = f"""SELECT ranking
FROM (
    SELECT RANK() OVER (ORDER BY P.{rank_name}_score DESC) AS ranking, CC.company, P.{rank_name}_score, P.eval_year
    FROM COMPANY CC
    JOIN PRISM_SCORE P ON CC.company_id = P.company_id
    WHERE P.eval_year = {dict_row["eval_year"]}
    AND CC.industry_id = (
        SELECT I.industry_id
        FROM COMPANY C
        JOIN INDUSTRY I ON C.industry_id = I.industry_id
        WHERE C.company = '{company_name}' -- 랭킹 보고 싶은 기업 이름 넣기
    )
) AS rankings
WHERE company = '{company_name}'; -- 랭킹 보고 싶은 기업 이름 넣기"""
                cursor.execute(sql)
                temp = cursor.fetchone()
                if temp == None:
                    rank = -1
                else:
                    rank = temp[0]
                print("ind_"+rank_name+"_rank", rank)
                dict_row["ind_"+rank_name+"_rank"] = rank
            #json_data.append(dict_row)
            #Wprism랭킹
            for rank_name in ["e", "s", "g", "overall"]:
                sql = f"""SELECT ranking, company, w_{rank_name}_score, eval_year
FROM (
SELECT RANK() OVER (ORDER BY P.w_{rank_name}_score DESC) AS ranking, CC.company, P.w_{rank_name}_score, P.eval_year
FROM COMPANY CC
JOIN PRISM_SCORE P ON CC.company_id = P.company_id
WHERE P.eval_year = {dict_row["eval_year"]}
    ) AS rankings
    WHERE company = '{company_name}';  -- 랭킹 보고 싶은 기업 이름 넣기"""
                cursor.execute(sql)
                temp = cursor.fetchone()
                if temp == None:
                    rank = -1
                else:
                    rank = temp[0]
                print("w_"+rank_name+"_rank", rank)
                dict_row["w_"+rank_name+"_rank"] = rank
            #프론트는 id가 필요없다!
            for delete in ["prism_score_id", "company_id"]:
                dict_row.pop(delete)
            json_data.append(dict_row)
        dp(json_data)
        serial_prism_score = OneCompanyPrismScoreSerializer(data = json_data, many = True)
        serial_prism_score.is_valid(raise_exception=True)
        exporting_data[0].update({"prism_scores" : serial_prism_score.data})
    
    #prism_ind_avg_score 불러와야함
    dp(industry_ids)
    piases = []
    for year_companyname, industry_id in zip(list_of_year_companyname, industry_ids):
        year, company_name = year_companyname.strip().split("_")
        pias = PrismIndAvgScore.objects.filter(Q(eval_year = year) & Q(industry_id = industry_id))
        piases.append(pias.values()[0])
    exporting_data[0].update({"prism_ind_avg_scores" : piases})

    kcgs = []
    for year_companyname, industry_id in zip(list_of_year_companyname, industry_ids):
        year, company_name = year_companyname.strip().split("_")
        kcgs_scores = KcgsScore.objects.filter(Q(company_id =company_id) & Q(eval_year = year))
        kcgs.append(kcgs_scores.values()[0])
    """serial_kcgs_scores = KcgsScoreSerializer(kcgs, many=True)
    dp(serial_kcgs_scores.data)
    exporting_data[0].update({"kcgs_scores" : serial_kcgs_scores.data})"""
    exporting_data[0].update({"kcgs_scores" : kcgs})

    esgs = []
    for year_companyname, industry_id in zip(list_of_year_companyname, industry_ids):
        year, company_name = year_companyname.strip().split("_")
        esglab_scores = EsglabScore.objects.filter(Q(company_id =company_id) & Q(eval_year = year))
        esgs.append(esglab_scores.values()[0])
    """serial_esglab_scores = EsglabScoreSerializer(esglab_scores, many=True)
    dp(serial_esglab_scores.data)
    exporting_data[0].update({"esglab_scores" : serial_esglab_scores.data})"""
    exporting_data[0].update({"esglab_scores" : esgs})
    return Response(exporting_data)










@api_view(["POST"])
def contextOfComparing(request):
    imported_data = request.data
    exporting_data = [{}]

    try:
        sustain_report_ids:list[int] = []
        gri_indexes:list[int] = []
        list_of_year_companyname:list[str] = imported_data["reports"]
        gri_sub_nums = imported_data["gri_indexes"]
    except:
        Response("F->B KeyError!", status=status.HTTP_400_BAD_REQUEST)
    with connection.cursor() as cursor:
        for year_companyname in list_of_year_companyname:
            year, company_name = year_companyname.strip().split("_")
            sql = f"SELECT * FROM COMPANY WHERE company='{company_name}'"
            cursor.execute(sql)
            data = cursor.fetchone()
            if data == None:
                return Response("This Company is not in DB", status=status.HTTP_400_BAD_REQUEST)
            company_id = data[0]
            print(company_id, year)
            sql = f"SELECT sustain_report_id FROM SUSTAIN_REPORT WHERE company_id={company_id} and eval_year={int(year)};"
            cursor.execute(sql)
            data = cursor.fetchone()
            if data == None:
                return Response("DB constructure Error", status=status.HTTP_404_NOT_FOUND)
            sustain_report_ids.append(data[0])
        for gri_sub_num in gri_sub_nums:
            sql = f"SELECT gri_index_id FROM GRI_INDEX WHERE sub_num='{gri_sub_num}'"
            cursor.execute(sql)
            data = cursor.fetchone()
            if data == None:
                return Response("This filter is irregular!", status=status.HTTP_400_BAD_REQUEST)
            gri_indexes.append(data[0])

    #필터링 조건 설정
    conditions = []
    pprint.pprint(gri_indexes)
    for gri_index in gri_indexes:
        conditions.append(Q(gri_index_id = gri_index))
    if len(conditions) == 0:
        exporting_data = [{"report_sentences" : [], "report_tables" : []}]
        return Response(exporting_data)
    for sustain_id in sustain_report_ids:
        #이제 각 sustainreport마다 주어진 필터링에 해당하는 걸로만 고를거다!
        #해당보고서에 해당하는 보고서테이블들중에서 필터링에 해당하는 것만 들고온다
         
        ret = ReportTable.objects.filter(sustain_report_id = sustain_id).filter(reduce(or_, conditions))
        #해당고서에 해당하는 보고서문장들
        res = ReportSentences.objects.filter(sustain_report_id = sustain_id).filter(reduce(or_, conditions))
        #report_sentences부분
        report_sentences = []
        for subres in list(res.values("gri_index","page_num","back_sentences","preced_sentences","most_sentences","sim_rank")):
            #subres는 {"gri_index" = 값, "page_num" = 값} 이런형태일것
            gri_index_id = subres["gri_index"]
            subres["gri_index"] = GriIndex.objects.filter(gri_index_id = gri_index_id).values_list("sub_num", flat=True).first()
            report_sentences.append(subres)
        exporting_data[0].update({"report_sentences" : report_sentences})

        #report_tables부분
        report_tables =[]
        for subret in list(ret.values("gri_index", "sim_rank", "html_code", "page_num")):
            #subres는 {"gri_index" = 값, "page" = 값} 이런형태일것
            gri_index_id = subret["gri_index"]
            subret["gri_index"] = GriIndex.objects.filter(gri_index_id = gri_index_id).values_list("sub_num", flat=True).first()
            report_tables.append(subret)
        exporting_data[0].update({"report_tables" : report_tables})
    
    return Response(exporting_data)
    