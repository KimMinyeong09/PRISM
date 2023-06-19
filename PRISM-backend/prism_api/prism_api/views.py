from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .serializers import *
from django.conf import settings
from django.db import connection
import pprint

#프린트디버깅용
def dp(sql_result):
    print("###########디버깅시작")
    pprint.pprint(sql_result)
    print("#####디버깅종료")

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

@api_view(["POST"])
def oneOfPage(request):
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
    results = results[NUM_ROW_OF_ONE_PAGE*(page-1) : NUM_ROW_OF_ONE_PAGE*(page)-1]
    
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

"""@api_view(["POST"])
def gricontext(request):
    imported_data = request.data
    with connection.cursor() as cursor:
        try:
            #json해독
            reports:list = imported_data["reports"]
            gri_indexes:list = imported_data["gri_indexes"]
            #sql질의
            sql = f""
        except:
            pass
"""
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
