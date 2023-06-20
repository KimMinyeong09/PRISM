import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prism/screens/detail_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_data.dart';
import '../models/esglab_ind_avg_score_model.dart';
import '../models/esglab_score_model.dart';
import '../models/gri_info_model.dart';
import '../models/gri_usage_ind_avg_score_model.dart';
import '../models/kcgs_ind_avg_score_model.dart';
import '../models/kcgs_score_model.dart';
import '../models/one_row_model.dart';
import '../models/prism_ind_avg_score_model.dart';
import '../models/prism_score_model.dart';
import '../models/sustain_report_model.dart';
import '../services/api_services.dart';


// 하드 코딩용 class
class ReportSentencesModel {
  final int sustain_report_id, gri_info_id,report_senetences_id, sim_rank, page;
  final String most_sentence, preced_sentences, back_sentences;

  ReportSentencesModel({
    required this.sustain_report_id, required this.gri_info_id, required this.report_senetences_id, required this.sim_rank, required this.page,
    required this.most_sentence, required this.preced_sentences, required this.back_sentences
  });
}

class ReportTableModel {
  final int sustain_report_id, gri_info_id, report_table_id, sim_rank, page;
  final String title, Html_code;

  ReportTableModel({
    required this.sustain_report_id, required this.gri_info_id, required this.report_table_id, required this.sim_rank, required this.page,
    required this.title, required this.Html_code
  });
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 사이드 메뉴용 변수
  SideMenuController side_menu = SideMenuController();
  PageController page = PageController();

  // 랭킹용 변수
  late TabController tab_controller;
  late int _current_page = 0; // 페이징
  // * 필터링
  // ** 필터링된 업종
  List<String> comparing_industries = [];
  // ** 필터링된 기업명
  String search_name = "";
  // * 랭킹 내 비교 선택 저장 변수
  List<String> comparing_items = [];

  // 비교용 변수
  // * 필터링
  // ** 필터링된 gri
  List<String> comparing_gris = [];
  // *** 선택된 기업 사이드메뉴에서 삭제 가능 / 불가능
  bool remove_comparing_items = true;

  // API- 회사 정보 저장 (하드코딩)
  late List<ReportSentencesModel> gri_infos;
  late List<ReportTableModel> report_tables;

  // 업종 리스트
  List<String> industries = [
    '에너지장비및서비스',
    '석유와가스',
    '화학',
    '포장재',
    '비철금속',
    '철강',
    '종이와목재',
    '우주항공과국방',
    '건축제품',
    '건축자재',
    '건설',
    '가구',
    '전기장비',
    '복합기업',
    '기계',
    '조선',
    '무역회사와판매업체',
    '상업서비스와공급품',
    '항공화물운송과물류',
    '항공사',
    '해운사',
    '도로와철도운송',
    '운송인프라',
    '자동차와부품',
    '가정용기기와용품',
    '레저용장비와제품',
    '섬유,의류,신발,호화품,문구류',
    '화장품',
    '호텔,레스토랑,레저등',
    '소매유통',
    '교육서비스',
    '식품과기본식료품소매',
    '식품,음료,담배',
    '가정용품과개인용품',
    '건강관리장비와서비스',
    '생물공학',
    '제약',
    '생명과학도구및서비스',
    '금융',
    '소프트웨어와서비스',
    '기술하드웨어와장비',
    '반도체와반도체장비',
    '전자와전기제품',
    '디스플레이',
    '전기통신서비스',
    '광고',
    '방송과엔터테인먼트',
    '출판',
    '게임엔터테인먼트',
    '양방향미디어와서비스',
    '전기,가스 유틸리티',
  ];

  // GRI 리스트
  final List<String> gri_mains = ["200", "300", "400",];
  final List<String> gri_mids = [
    "201", "202", "203", "204", "205" ,"206",
    "301", "302", "303", "304", "305", "306", "307", "308",
    "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414", "415", "416", "417", "418", "419"];
  final List<String> gri_subs = [
    "201-1", "201-2", "201-3", "201-4",
    "202-1", "202-2",
    "203-1", "203-2",
    "204-1",
    "205-1", "205-2", "205-3",
    "206-1",
    
    "301-1", "301-2", "301-3",
    "302-1", "302-2", "302-3", "302-4", "302-5",
    "303-1", "303-2", "303-3", "303-4", "303-5",
    "304-1", "304-2", "304-3", "304-4",
    "305-1", "305-2", "305-3", "305-4", "305-5", "305-6", "305-7",
    "306-1", "306-2", "306-3", "306-4", "306-5",
    "307-1",
    "308-1", "308-2",
    
    "401-1", "401-2", "401-3",
    "402-1",
    "403-1", "403-2", "403-3", "403-4", "403-5", "403-6", "403-7", "403-8", "403-9", "403-10",
    "404-1", "404-2", "404-3",
    "405-1", "405-2",
    "406-1",
    "407-1",
    "408-1",
    "409-1",
    "410-1",
    "411-1",
    "412-1", "412-2", "412-3",
    "413-1", "413-2",
    "414-1", "414-2",
    "415-1",
    "416-1", "416-2",
    "417-1", "417-2", "417-3",
    "418-1",
    "419-1"
  ];
  final List<String> gri_subs_name = ["직접적 경제가치 발생과 분배(EVG&D)", "기후변화에 따른 재무적 영향 및 기타 리스크와 기회", "확정급여형 연금 채무 및 기타 퇴직연금안", "정부 재정지원",
"사업장 소재 지역의 최저 임금 대비 초임 임금의 비율 (성별에 따라 파악)",
"사업장이 소재한 지역사회에서 고용된 고위 임원의 비율",
"사회기반시설 투자 및 서비스 지원",
"중요한 간접 경제 영향",
"지역 공급업체에 지출하는 비용의 비중",
"사업장 부패 리스크 평가",
"반부패 정책과 절차에 관한 커뮤니케이션 및 교육",
"확인된 부패 사례 및 조치",
"경쟁저해 및 독과점금지 위반 관련 소송",
"사용된 원재료의 중량 또는 용량",
"재생 투입 원자재",
"재생된 제품 및 포장재",
"조직 내 에너지 소비",
"조직 외부에서의 에너지 소비",
"에너지 집약도",
"에너지 소비 감축",
"제품 및 서비스의 에너지 요구량 감축",
"공유 자원으로서의 물과의 상호작용",
"물 방류 관련 영향 관리",
"취수",
"방류",
"물 소비",
"보호지역 및 생물다양성 가치가 높은 지역 내 또는 그 인근에서 소유/임대/운영되는 사업장",
"조직의 활동, 제품, 서비스가 생물다양성에 미치는 중대한 영향",
"보호 또는 복원된 서식지",
"IUCN 적색목록 및 조직 사업의 영향을 받는 지역 내에 서식하는 국가보호종 목록",
"직접 온실가스 배출량 (Scope1)",
"간접 온실가스 배출량 (Scope2)",
"기타 간접 온실가스 배출량 (Scope3)",
"온실가스 배출 집적도",
"온실가스 배출량 감축",
"오존층 파괴 물질(ODS) 배출량",
"질소산화물(NOx), 황산화물(SOx) 및 기타 중요한 대기 배출량",
"수질 및 목적지별 방류",
"유형별, 처리방법별 폐기물",
"중대한 유출",
"유해 폐기물의 운반",
"방류 또는 유출의 영향을 받는 수역",
"환경 규제 위반",
"환경 기준 심사를 거친 신규 공급업체",
"공급망의 부정적 환경 영향 및 이에 대한 조치",
"신규채용 및 이직",
"비정규직 근로자에게는 제공되지 않는 정규직 근로자를 위한 복리후생",
"육아휴직",
"운영상의 변화와 관련한 최소 공지기간",
"직장 건강 및 안전 관리 시스템",
"위험요인 파악, 리스크 평가, 사고 조사",
"직장 의료 서비스",
"직장 건강 및 안전 관련 커뮤니케이션, 자문 및 근로자 참여",
"직장 건강 및 안전 관련 근로자 교육",
"근로자 건강 증진",
"비즈니스 관계와 직접적으로 연계된 직장 건강 및 안전 영향의 예방과 완화",
"직장 건강 및 안전 관리 시스템의 적용 대상 근로자",
"업무 관련 부상",
"업무 관련 질병",
"직원 1인당 평균 교육 시간",
"직원 역량강화 및 이직지원 프로그램",
"정기적으로 성과 및 경력 개발 검토를 받는 직원 비율",
"지배구조 기구와 직원의 다양성",
"남성 대비 여성의 기본급 및 보수 비율",
"차별 사례 및 이에 대한 시정조치",
"집회결사 및 단체교섭권 훼손 위험이 있는 사업장 및 공급업체",
"아동노동 발생 위험이 높은 사업장 및 공급업체",
"강제 노역 발생 위험이 높은 사업장 및 공급업체",
"인권 정책 및 절차에 관한 교육을 받은 보안 담당자",
"원주민 권리 침해 사례",
"인권 관련 검토 또는 영향 평가 대상 사업장",
"인권 정책 및 절차 관련 직원 교육",
"인권 관련 조항을 포함하고 있거나 인권 심사를 받은 주요 투자 협정 및 계약",
"지역사회 참여, 영향 평가 및 개발 프로그램 운영 사업장",
"지역사회에 중대한 실제적/잠재적 부정적 영향을 미치는 사업장",
"사회적 기준에 따른 심사를 거친 신규 공급업체",
"공급망 내 부정적 사회적 영향 및 그에 대한 대응조치",
"정치 기부금",
"제품/서비스의 건강 및 안전 영향 평가",
"제품/서비스의 건강 및 안전 영향 관련 위반",
"제품/서비스 관련 정보 및 라벨링 요건",
"제품/서비스 정보 및 라벨링 관련 위반",
"마케팅 커뮤니케이션 관련 위반",
"고객 개인정보보호 위반 및 고객정보 분실 관련해 입증된 민원",
"사회적 및 경제적 분야의 법률 및 규정 위반",];

  @override
  void initState() {
    // 사이드 메뉴 페이지 이동
    side_menu.addListener((p0) {
      page.jumpToPage(p0);
    });

    // 랭킹 탭
    tab_controller = TabController(length: 8, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tab_controller.dispose();
    super.dispose();
  }

  // api
  List<int> companyYears = [];
  void fetchCompanyYearData(String comapny_name) async {
    try {
      companyYears = await ApiService.outCompanyYears(comapny_name);
      // 반환된 데이터를 사용하여 원하는 동작 수행
      print(companyYears);
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    }
  }

  late List<OneRowModel> one_row_list = [];  // ranking tab에서 이용
  void fetchOnePageData(String filter_score, int page) async {
    try {
      // print(page);
      // print(filter_score);
      List<OneRowModel> one_pages = await ApiService.outOnePage(page, filter_score, comparing_industries, search_name);
      // print(one_pages);
      setState(() {
        one_row_list = one_pages;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // 세부페이지에서 사용할 해당 기업의 지속가능경영보고서 발행 연도들 - 상단바 / PRISM스코어 탭 / 평가기관등급 탭에 사용
  late List<int> detail_info_years = [];
  // 세부페이지 - PRISM스코어 탭에서 사용할 정보
  late Map<int, Map<String, dynamic>> detail_prism_info = {};
  // 세부페이지 - 평가기관등급 탭에서 사용할 정보
  late Map<int, Map<String, dynamic>> detail_association_info = {};
  // 세부페이지 - ESG 정보 탭에서 사용할 정보 (ESG 비율)
  late Map<String, dynamic> detail_esg_info = {};
  // 세부페이지 - ESG 정보 탭: gri_index 목록
  late List<String> detail_gri_index = [];
  // 세부페이지 - 상단바 : 지속가능경영보고서 다운로드 링크
  late Map<int, String> detail_download_links = {};

  List<int> years = [];
  Map<int, Map<String, dynamic>> b_prism_info = {};
  Map<int, Map<String, dynamic>> i_prism_info = {};
  Map<int, Map<String, dynamic>> k_association_info = {};
  Map<int, Map<String, dynamic>> el_association_info = {};
  Map<int, Map<String, dynamic>> k_a_association_info = {};
  Map<int, Map<String, dynamic>> el_a_association_info = {};
  Map<int, String> download_links = {};
  Map<String, dynamic> esg_info = {};
  Map<String, dynamic> ind_esg_info = {};
  List<String> gri_index = [];
  void fetchCompanyDetailData(String company_name) async {
    try {
      years = [];
      b_prism_info = {};
      i_prism_info = {};
      el_association_info = {};
      k_a_association_info = {};
      el_a_association_info = {};
      download_links = {};
      esg_info = {};
      ind_esg_info = {};
      gri_index = [];

      // SecondPage로 보내는 데이터 처음에 초기화
      detail_info_years = [];
      detail_prism_info = {};
      detail_association_info = {};
      detail_esg_info = {};
      detail_gri_index = [];
      detail_download_links = {};

      List<PrismScoreModel> prism_scores = await ApiService.outPrismScores(company_name);
      for (var prism_score in prism_scores) {
        years.add(prism_score.evalYear);
        b_prism_info[prism_score.evalYear] = {
          'overallScore': prism_score.overallScore,
          'EScore': prism_score.EScore,
          'SScore': prism_score.SScore,
          'GScore': prism_score.GScore,
          'WOverallScore': prism_score.WOverallScore,
          'WEScore': prism_score.WEScore,
          'WSScore': prism_score.WSScore,
          'WGScore': prism_score.WGScore,
          'overallRank': prism_score.overallRank,
          'Erank': prism_score.Erank,
          'Srank': prism_score.Srank,
          'Grank': prism_score.Grank, 
          'indOverallRank': prism_score.indOverallRank,
          'indERank': prism_score.indERank,
          'indSRank': prism_score.indSRank,
          'indGRank': prism_score.indGRank
        };
      }
      years.sort((a, b) => b.compareTo(a));
      
      List<PrismIndAvgScoreModel> prism_ind_avg_scores = await ApiService.outPrismIndAvgScores(company_name);
      for (var prism_ind_avg_score in prism_ind_avg_scores) {
        i_prism_info[prism_ind_avg_score.year] = {
          'indOverallScore': prism_ind_avg_score.overallScore,
          'indEScore': prism_ind_avg_score.EScore,
          'indSScore': prism_ind_avg_score.SScore,
          'indGScore': prism_ind_avg_score.GScore,
          'indWOverallScore': prism_ind_avg_score.wOverallScore,
          'indWEScore': prism_ind_avg_score.wEScore, 
          'indWSScore': prism_ind_avg_score.wSScore,
          'indWGScore': prism_ind_avg_score.wGScore,
        };
      }
      print("----------------------------------------");
      print(years);
      print(b_prism_info);
      print(i_prism_info);
      print("----------------------------------------");

      Map<int, Map<String, dynamic>> prism_info = {};
      b_prism_info.forEach((key, value) {
        prism_info[key] = value;
      });
      i_prism_info.forEach((key, value) {
        if (prism_info.containsKey(key)) {
          if (prism_info[key] != null) {
            prism_info[key]!.addAll(value);
          } else {
            prism_info[key] = {}..addAll(value);
          }
        } else {
          prism_info[key] = value;
        }
      });

      List<KcgsScoreModel> kcgs_scores = await ApiService.outKcgsScores(company_name);
      for (var kcgs_score in kcgs_scores) {
        k_association_info[kcgs_score.evalYear] = {
          'kcgsOverallScore': kcgs_score.overallScore,
          'kcgsEScore': kcgs_score.EScore,
          'kcgsSScore': kcgs_score.SScore,
          'kcgsGScore': kcgs_score.GScore,
        };
      }
      
      List<EsglabScoreModel> esglab_scores = await ApiService.outEsglabScores(company_name);
      for(var esglab_score in esglab_scores) {
        el_association_info[esglab_score.evalYear] = {
          'esglabOverallScore': esglab_score.overallScore,
          'esglabEScore': esglab_score.EScore,
          'esglabSScore': esglab_score.SScore,
          'esglabGScore': esglab_score.GScore,
        };
      }
      List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = await ApiService.outKcgsIndAvgScores(company_name);
      for (var kcgs_ind_avg_score in kcgs_ind_avg_scores) {
        k_a_association_info[kcgs_ind_avg_score.year] = {
          'kcsgAvgOverallScore': kcgs_ind_avg_score.overallScore,
          'kcsgAvgEScore': kcgs_ind_avg_score.EScore,
          'kcsgAvgSScore': kcgs_ind_avg_score.SScore,
          'kcsgAvgGScore': kcgs_ind_avg_score.GScore,
        };
      }
      List<EsglabIndAvgScoreModel> esglab_ind_avg_scores = await ApiService.outEsglabIndAvgScores(company_name);
      for (var esglab_ind_avg_score in esglab_ind_avg_scores) {
        el_a_association_info[esglab_ind_avg_score.year] = {
          'esglabAvgOverallScore': esglab_ind_avg_score.overallScore,
          'esglabAvgEScore': esglab_ind_avg_score.EScore,
          'esglabAvgSScore': esglab_ind_avg_score.SScore,
          'esglabAvgGScore': esglab_ind_avg_score.GScore,
        };
      }

      Map<int, Map<String, dynamic>> association_info = {};
      k_association_info.forEach((key, value) {
        association_info[key] = value;
      });
      el_association_info.forEach((key, value) {
        if (association_info.containsKey(key)) {
          if (association_info[key] != null) {
            association_info[key]!.addAll(value);
          } else {
            association_info[key] = {}..addAll(value);
          }
        } else {
          association_info[key] = value;
        }
      });
      k_a_association_info.forEach((key, value) {
        if (association_info.containsKey(key)) {
          if (association_info[key] != null) {
            association_info[key]!.addAll(value);
          } else {
            association_info[key] = {}..addAll(value);
          }
        } else {
          association_info[key] = value;
        }
      });
      el_a_association_info.forEach((key, value) {
        if (association_info.containsKey(key)) {
          if (association_info[key] != null) {
            association_info[key]!.addAll(value);
          } else {
            association_info[key] = {}..addAll(value);
          }
        } else {
          association_info[key] = value;
        }
      });

      List<SustainReportModel> sustain_reports = await ApiService.outSustainReports(company_name);
      for(var sustain_report in sustain_reports) {
        print(sustain_report.year);
        print(sustain_report.download_link);
        download_links[sustain_report.year] = sustain_report.download_link;
        if (years[0] == sustain_report.year){
          esg_info = {
            'Escore': sustain_report.e_score,
            'Sscore': sustain_report.s_score,
            'Gscore': sustain_report.g_score,
          };
        }
        
      }
      print(download_links);
      
      List<GriUsageIndAvgScoreModel> gri_usage_ind_avg_scores = await ApiService.outGriUsageIndAvgScores(company_name);
      for(var gri_usage_ind_avg_score in gri_usage_ind_avg_scores) {
        if (years[0] == gri_usage_ind_avg_score.year){
          ind_esg_info = {
            'indEscore': gri_usage_ind_avg_score.E_score,
            'indSscore': gri_usage_ind_avg_score.S_score,
            'indGscore': gri_usage_ind_avg_score.G_score,
          };
        }
      }

      Map<String, dynamic> esg_rates = {...esg_info, ...ind_esg_info};

      List<GriInfoModel> gri_infos = await ApiService.outGriInfos(company_name);
      for (var gri_info in gri_infos) {
        gri_index.add(gri_info.gri_index);
      }

      // await ApiService.outReportSentencess(company_name);
      // await ApiService.outReportTables(company_name);
      

      setState(() {
        detail_info_years = years;
        detail_prism_info = prism_info;
        detail_association_info = association_info;
        detail_download_links = download_links;
        detail_esg_info = esg_rates;
        detail_gri_index = gri_index;
        print(detail_info_years);
        print(detail_prism_info);
        print(detail_association_info);
        print(detail_download_links);
        print(detail_esg_info);
        print("---------------");
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  late List<Map<String, dynamic>> fetch_comparing_datas = [];
  void fetchComparingData(List<Map<String, int>> company_and_year) async {
    
    List<PrismScoreModel> prism_scores = await ApiService.outPrismScore(company_and_year);
    List<PrismIndAvgScoreModel> prism_ind_avg_scores = await ApiService.outPrismIndAvgScore(company_and_year);
    List<KcgsScoreModel> kcgs_scores = await ApiService.outKcgsScore(company_and_year);
    List<EsglabScoreModel> esglab_scores = await ApiService.outEsglabScore(company_and_year);

    for (var i = 0; i < company_and_year.length; i++) {
      fetch_comparing_datas.add(
        {
          "overallScore" : prism_scores[i].overallScore,
          "EScore" : prism_scores[i].EScore,
          "SScore" : prism_scores[i].SScore,
          "GScore" : prism_scores[i].GScore,

          "overallRank" : prism_scores[i].overallRank,
          "Erank" : prism_scores[i].Erank,
          "Srank" : prism_scores[i].Srank,
          "Grank" : prism_scores[i].Grank,

          "indOverallRank" : prism_scores[i].indOverallRank,
          "indERank" : prism_scores[i].indERank,
          "indSRank" : prism_scores[i].indSRank,
          "indGRank" : prism_scores[i].indGRank,

          "WOverallScore" : prism_scores[i].WOverallScore, 
          "WEScore" : prism_scores[i].WEScore,
          "WSScore" : prism_scores[i].WSScore,
          "WGScore" : prism_scores[i].WGScore,

          "WOverallRank" : prism_scores[i].WOverallRank,
          "WERank" : prism_scores[i].WERank,
          "WSRank" : prism_scores[i].WSRank,
          "WGRank" : prism_scores[i].WGRank, 

          "indOverallScore" : prism_ind_avg_scores[i].overallScore,
          "indEScore" : prism_ind_avg_scores[i].EScore,
          "indSScore" : prism_ind_avg_scores[i].SScore,
          "indGScore" : prism_ind_avg_scores[i].GScore,

          "indWOverallScore" : prism_ind_avg_scores[i].wOverallScore,
          "indWEScore" : prism_ind_avg_scores[i].wEScore,
          "indWSScore" : prism_ind_avg_scores[i].wSScore,
          "indWGScore" : prism_ind_avg_scores[i].wGScore,

          "kcgsOverallScore" : kcgs_scores[i].overallScore,
          "kcgsEScore" : kcgs_scores[i].EScore,
          "kcgsSScore" : kcgs_scores[i].SScore,
          "kcgsGScore" : kcgs_scores[i].GScore,

          "esglabOverallScore" : esglab_scores[i].overallScore,
          "esglabEScore" : esglab_scores[i].EScore,
          "esglabSScore" : esglab_scores[i].SScore,
          "esglabGScore" : esglab_scores[i].GScore
        }
      );
    }

    setState(() {
      fetch_comparing_datas;
      print(fetch_comparing_datas);
    });

    // await ApiService.outSustainReport(company_and_year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 사이드 메뉴
          SideMenu(
            controller: side_menu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              selectedColor: const Color(0xffD7EDFF),
              selectedTitleTextStyle: const TextStyle(color: Color(0xff0E73F6)),
              selectedIconColor: const Color(0xff4A41FF),
              unselectedTitleTextStyle:
                  const TextStyle(color: Color(0xff0E73F6)),
              unselectedIconColor: const Color(0xff972ACA),
              backgroundColor: const Color(0xffF6F8F9),
              iconSize: 40,
              openSideMenuWidth: 200,
              compactSideMenuWidth: 80,
              itemHeight: 65,
            ),
            title: const Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Image(
                          image:
                              AssetImage('../../assets/images/PRISM-logo.png'),
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "PRISM",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Ranking',
                onTap: (page, _) {
                  side_menu.changePage(page);
                  remove_comparing_items = true;
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Comparing',
                onTap: (page, _) {
                  side_menu.changePage(page);
                  remove_comparing_items = false;
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                priority: 2,
                title: comparing_items.isNotEmpty ? comparing_items[0] : "",
                onTap: (page, _) {
                  if (remove_comparing_items) {
                    comparing_items.remove(comparing_items[0]);
                    setState(() {});
                  }
                },
              ),
              SideMenuItem(
                priority: 2,
                title: comparing_items.length > 1 ? comparing_items[1] : "",
                onTap: (page, _) {
                  if (remove_comparing_items) {
                    comparing_items.remove(comparing_items[1]);
                    setState(() {});
                  }
                },
              ),
              SideMenuItem(
                priority: 2,
                title: comparing_items.length == 3 ? comparing_items[2] : "",
                onTap: (page, _) {
                  if (remove_comparing_items) {
                    comparing_items.remove(comparing_items[2]);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                // 랭킹 페이지
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        const Text(
                          'ESG 랭킹',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // 탭
                        TabBar(
                          controller: tab_controller,
                          tabs: const [
                            Tab(text: 'prism-ALL'),
                            Tab(text: 'prism-E'),
                            Tab(text: 'prism-S'),
                            Tab(text: 'prism-G'),
                            Tab(text: 'Wprism-ALL'),
                            Tab(text: 'Wprism-E'),
                            Tab(text: 'Wprism-S'),
                            Tab(text: 'Wprism-G'),
                          ],
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tab_controller,
                            children: [
                              if (tab_controller.index == 0) ...[
                                rankingTab(context, "prism-ALL"),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 1) ...[
                                Container(),
                                rankingTab(context, "prism-E"),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 2) ...[
                                Container(),
                                Container(),
                                rankingTab(context, "prism-S"),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 3) ...[
                                Container(),
                                Container(),
                                Container(),
                                rankingTab(context, "prism-G"),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 4) ...[
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                rankingTab(context, "Wprism-ALL"),
                                Container(),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 5) ...[
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                rankingTab(context, "Wprism-E"),
                                Container(),
                                Container(),
                              ],
                              if (tab_controller.index == 6) ...[
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                rankingTab(context, "Wprism-S"),
                                Container(),
                              ],
                              if (tab_controller.index == 7) ...[
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                Container(),
                                rankingTab(context, "Wprism-G"),
                              ],
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                // 비교 페이지
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comparingPage(context),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 비교 페이지
  List<Widget> comparingPage(BuildContext context) {

    return [
      const Text(
        "ESG 비교",
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      // GRI 필터링
      SizedBox(
        height: 80,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio:
              (MediaQuery.of(context).size.width - 200) / 100,
          children: [
            SizedBox(
              child: OutlinedButton.icon(
                onPressed: () {
                  chooseGRI(context);
                },
                icon: const Icon(
                  Icons.filter_list,
                  size: 18,
                  color: Color(0xff5B6871),
                ),
                label: const Text(
                  "GRI index",
                  style: TextStyle(
                    color: Color(0xff252C32),
                  ),
                ),
              ),
            ),
            // 선택된 업종 표시
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(comparing_gris.length,
                    (index) {
                  var gri = comparing_gris[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          comparing_gris.remove(gri);
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color(0xff4A41FF),
                      ),
                      child: Text(
                        gri,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      if (comparing_items.isNotEmpty)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: printComparingInfo(context),
          ),
        ),
    ];
  }

  // 비교 페이지 데이터 출력
  List<Widget> printComparingInfo(BuildContext context) {

    List<Map<String, int>> company_and_year=[];
                  for (var comparing_item in comparing_items) {
                    String item = comparing_item;
                    List<String> splitText = item.split("\n");
                    String companyName = splitText[0];
                    int companyYear = int.parse(splitText[1]);
                    company_and_year.add({companyName: companyYear});
                  }
    fetchComparingData(company_and_year);

    var reportSentencesModel = ReportSentencesModel(
        sustain_report_id: 1, gri_info_id: 1, report_senetences_id: 1, sim_rank: 1, page: 50,
        most_sentence: "중요 문장!!", preced_sentences: "이전문장", back_sentences: "이후문장",
      );
    var reportTableModel = ReportTableModel(
        sustain_report_id: 1, gri_info_id: 1, report_table_id: 1, sim_rank: 1, page: 60,
        title: "제목", Html_code: "String",
      );

    
    gri_infos = [
        for (var i = 0; i < comparing_items.length; i++)
          reportSentencesModel,
      ];
      report_tables = [
        for (var i = 0; i < comparing_items.length; i++)
          reportTableModel,
      ];
    if (fetch_comparing_datas.isEmpty)
      return List.generate(comparing_items.length, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        );
      });
    return List.generate(
      comparing_items.length, (index) {
      String item = comparing_items[index];
      List<String> splitText = item.split("\n");
      String companyName = splitText[0];
      String companyYear = splitText[1];

      print("here!");
      print(index);
      print(fetch_comparing_datas[index]);
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 기업명 & 연도
          SizedBox(
            width: 200,
            height:
                MediaQuery.of(context).size.height /
                    4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  companyName,
                  style:
                      const TextStyle(fontSize: 20),
                ),
                Text(companyYear),
              ],
            ),
          ),
          // PRISM 스코어
          Row(
            children: [
              _buildDChart(
                companyName, "PRISM 스코어",
                fetch_comparing_datas[index]['overallScore'], fetch_comparing_datas[index]['indOverallScore'],
                fetch_comparing_datas[index]['overallRank'],fetch_comparing_datas[index]['indOverallRank']
              ),
              _buildDChart(
                companyName, "E",
                fetch_comparing_datas[index]['EScore'], fetch_comparing_datas[index]['indEScore'],
                fetch_comparing_datas[index]['Erank'],fetch_comparing_datas[index]['indERank']
              ),
              _buildDChart(
                companyName, "S",
                fetch_comparing_datas[index]['SScore'], fetch_comparing_datas[index]['indSScore'],
                fetch_comparing_datas[index]['Srank'],fetch_comparing_datas[index]['indSRank']
              ),
              _buildDChart(
                companyName, "G",
                fetch_comparing_datas[index]['GScore'], fetch_comparing_datas[index]['indGScore'],
                fetch_comparing_datas[index]['Grank'],fetch_comparing_datas[index]['indGRank']
              ),
            ],
          ),
          // wPRISM 스코어
          Row(
            children: [
              _buildDChart(
                companyName, "wPRISM 스코어",
                fetch_comparing_datas[index]['WOverallScore'], fetch_comparing_datas[index]['indWOverallScore'],
                fetch_comparing_datas[index]['WOverallRank'],fetch_comparing_datas[index]['WOverallRank']
              ),
              _buildDChart(
                companyName, "wE",
                fetch_comparing_datas[index]['WEScore'], fetch_comparing_datas[index]['indWEScore'],
                fetch_comparing_datas[index]['WERank'],fetch_comparing_datas[index]['WERank']
              ),
              _buildDChart(
                companyName, "wS",
                fetch_comparing_datas[index]['WSScore'], fetch_comparing_datas[index]['indWSScore'],
                fetch_comparing_datas[index]['WSRank'],fetch_comparing_datas[index]['WSRank']
              ),
              _buildDChart(
                companyName, "wG",
                fetch_comparing_datas[index]['WGScore'], fetch_comparing_datas[index]['indWGScore'],
                fetch_comparing_datas[index]['WGRank'],fetch_comparing_datas[index]['WGRank']
              ),
            ],
          ),
          // KCGS
          _buildAssociationRakingTable(
            "KCGS",
            fetch_comparing_datas[index]['kcgsOverallScore'],
            fetch_comparing_datas[index]['kcgsEScore'],
            fetch_comparing_datas[index]['kcgsSScore'],
            fetch_comparing_datas[index]['kcgsGScore'],
          ),
          // 한국ESG연구소
          _buildAssociationRakingTable(
            "한국ESG연구소",
            fetch_comparing_datas[index]['esglabOverallScore'],
            fetch_comparing_datas[index]['esglabEScore'],
            fetch_comparing_datas[index]['esglabSScore'],
            fetch_comparing_datas[index]['esglabGScore'],
          ),
          // GRI info
          if (comparing_gris.isEmpty)
            SizedBox(
                height: MediaQuery.of(context)
                        .size
                        .height /
                    4,
                child: const Text(
                    "GRI index를 선택해주세요 (최대 5개)"))
          else
            for (var comparing_gri in comparing_gris)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: MediaQuery.of(context)
                            .size
                            .height /
                        4,
                    child: Row(
                      children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("[$comparing_gri]", style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(gri_subs.indexOf(comparing_gri) != -1 ? gri_subs_name[gri_subs.indexOf(comparing_gri)] : "" , style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          // 텍스트
                          extractSentences(gri_infos[index]),
                          extractSentences(gri_infos[index]),
                          extractSentences(gri_infos[index]),
                          // 표
                          extractTable(report_tables[index]),
                          extractTable(report_tables[index]),
                          extractTable(report_tables[index]),
                      ],
                    ),
                  ),
              ),
        ],
      );
    });
  }

  Padding extractTable(ReportTableModel report_table) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(report_table.title),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                child: Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text('Age', style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text('Role', style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
          ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Sarah')),
                  DataCell(Text('19')),
                  DataCell(Text('Student')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Janine')),
                  DataCell(Text('43')),
                  DataCell(Text('Professor')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('William')),
                  DataCell(Text('27')),
                  DataCell(Text('Associate Professor')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding extractSentences(ReportSentencesModel gri_info) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(gri_info.preced_sentences, style: const TextStyle(color: Colors.grey)),
          Text(gri_info.most_sentence),
          Text(gri_info.back_sentences, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  SizedBox _buildAssociationRakingTable(String association, String all, String e, String s, String g) {

    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(association, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Table(
              children: [
                TableRow(
                  children: [
                    const TableCell(child: Text("종합점수", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,), textAlign: TextAlign.center,)),
                    TableCell(child: Text(all, style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,)), // TODO: 점수 받아오기
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("E", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,), textAlign: TextAlign.center,)),
                    TableCell(child: Text(e, style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,)), // TODO: 점수 받아오기
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("S", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,), textAlign: TextAlign.center,)),
                    TableCell(child: Text(s, style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,)), // TODO: 점수 받아오기
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text("G", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,), textAlign: TextAlign.center,)),
                    TableCell(child: Text(g, style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,)), // TODO: 점수 받아오기
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildDChart(String companyName, String title, int score, int ind_score, int rank, int ind_rank) {
    
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: MediaQuery.of(context).size.height / 4 - 100,
          child: SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                dataSource: <ChartData>[
                  ChartData(companyName, score),
                  ChartData("업종", ind_score),
                ],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
              ),
            ],
            palette: const <Color>[
              Color(0xff7F56D9),
              Color(0xffF0D9FF),
            ],
            title: ChartTitle(
                text: title,
                textStyle: const TextStyle(
                  fontSize: 15,
                )),
            margin: const EdgeInsets.all(1),
          ),
        ),
        Text(score.toString(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        Text("업계 평균 ${ind_score}",
            style: const TextStyle(fontSize: 10, color: Color(0xff667085))),
        Text("업계 ${ind_rank}위",
            style: const TextStyle(fontSize: 10, color: Color(0xff667085))),
        Text("전체 ${rank}위",
            style: const TextStyle(fontSize: 10, color: Color(0xff667085))),
      ],
    );
  }

  // 랭킹 페이지 - 탭
  Container rankingTab(BuildContext context, String scoreName) {
    // comparing_industries, search_name, scoreName 이용해서 불러오기
    fetchOnePageData(scoreName, _current_page + 1);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            // 필러팅 섹션
            SizedBox(
              height: 80,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio:
                    (MediaQuery.of(context).size.width - 200) / 100,
                children: [
                  // 기업명 검색
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '기업명 검색..',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          search_name = value;
                        });
                      },
                    ),
                  ),
                  // 업종 필터링
                  SizedBox(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        chooseIndustries(context, scoreName);
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        size: 18,
                        color: Color(0xff5B6871),
                      ),
                      label: const Text(
                        "업종 필터링",
                        style: TextStyle(
                          color: Color(0xff252C32),
                        ),
                      ),
                    ),
                  ),
                  // 선택된 업종 표시
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          List.generate(comparing_industries.length, (index) {
                        var industry = comparing_industries[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                comparing_industries.remove(industry);
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xff4A41FF),
                            ),
                            child: Text(
                              industry,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            // 정보 표시
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '비교',
                      style: TextStyle(
                        color: Color(0xff84919A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('순위',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('기업명',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('업종',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('PRISM 스코어',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('ESG 평가기관',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('기업 정보',
                        style: TextStyle(
                          color: Color(0xff84919A),
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                10, // 한 페이지에 표시할 행의 개수
                (index) {
                  final rowIndex = (_current_page * 10) + index;
                  if (index >= one_row_list.length) {
                    return const DataRow(cells: [
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                    ]); // 빈 데이터 행 생성
                  } else {
                    return DataRow(
                      cells: [
                        DataCell(
                          IconButton(
                            onPressed: () {
                              fetchCompanyYearData(one_row_list[index].name);
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  // 연도 받아오기
                                  List<int> year = [2022, 2021, 2020];
                                  // List<int> year = companyYears;
                                  
                                  return AlertDialog(
                                    content: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(year.length, (idx) {
                                        int currentYear = year[idx];
                                        return TextButton(
                                          onPressed: () {
                                            if (comparing_items.contains('${one_row_list[index].name}\n$currentYear')) {
                                              comparing_items.remove('${one_row_list[index].name}\n$currentYear');
                                            } else {
                                              if (comparing_items.length < 3) {
                                                comparing_items.add('${one_row_list[index].name}\n$currentYear');
                                              }
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text(
                                            currentYear.toString(),
                                            style: TextStyle(
                                              fontWeight: comparing_items.contains('${one_row_list[index].name}\n$currentYear')
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        DataCell(Text((rowIndex + 1).toString())),
                        DataCell(Text(one_row_list[index].name)), // 수정
                        DataCell(Text(one_row_list[index].industry)), // 수정
                        DataCell(Text(one_row_list[index].score.toString())),
                        DataCell(
                          Row(
                            children: [
                              for (var tmp in one_row_list[index].esg_insts)
                                Text(" $tmp "),  
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () async {
                              fetchCompanyDetailData(one_row_list[index].name);
                              print(detail_info_years);
                              print(detail_download_links);
                              print("---------in");

                              await Future.delayed(Duration(seconds: 1)); // 1초 동안 지연: 데이터 불러오는 시간


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecondPage(
                                            one_row_list[index].name, one_row_list[index].industry,
                                            detail_info_years,
                                            detail_prism_info,
                                            detail_association_info,
                                            detail_download_links,
                                            detail_esg_info,
                                            detail_gri_index)));
                            },
                            icon: const Icon(Icons.arrow_right),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            NumberPaginator(
              // by default, the paginator shows numbers as center content
              numberPages: one_row_list.isNotEmpty ? one_row_list[0].pages_number : 1,
              onPageChange: (int index) {
                setState(() {
                  _current_page =
                      index; // _current_page is a variable within State of StatefulWidget
                });
              },
              // initially selected index
              initialPage: 0,
              config: const NumberPaginatorUIConfig(
                buttonSelectedForegroundColor: Colors.black,
                buttonUnselectedForegroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> chooseIndustries(BuildContext context, String scoreName) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부: 닫지 않음
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            (industries.length / 5).ceil(),
            (rowIndex) => Row(
              children: List.generate(
                5,
                (index) => (rowIndex * 5 + index < industries.length)
                    ? Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (comparing_industries
                                  .contains(industries[rowIndex * 5 + index])) {
                                comparing_industries
                                    .remove(industries[rowIndex * 5 + index]);
                              } else {
                                comparing_industries
                                    .add(industries[rowIndex * 5 + index]);
                              }
                            });
                          },
                          child: Text(
                            industries[rowIndex * 5 + index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: comparing_industries.contains(
                                      industries[rowIndex * 5 + index])
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                    : Expanded(child: Container()),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String?> chooseGRI(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < gri_mains.length; i++)
                ExpansionTile(
                  title: Text(gri_mains[i]),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int j = 0; j < gri_mids.length; j++)
                            if (gri_mids[j][0] == gri_mains[i][0])
                              ExpansionTile(
                                title: Text(gri_mids[j]),
                                controlAffinity: ListTileControlAffinity.leading,
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (int k = 0; k < gri_subs.length; k++)
                                          if (gri_subs[k].contains(gri_mids[j]))
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (comparing_gris.contains(gri_subs[k])) {
                                                      comparing_gris.remove(gri_subs[k]);
                                                    } else {
                                                      if (comparing_gris.length < 5) {
                                                        comparing_gris.add(gri_subs[k]);
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  '${gri_subs[k]}: ${gri_subs_name[k]}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        comparing_gris.contains(gri_subs[k])
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            
                                              

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}