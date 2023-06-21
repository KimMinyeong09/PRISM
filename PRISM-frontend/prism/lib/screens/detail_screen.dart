import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:prism/models/gri_info_model.dart';
import 'package:prism/models/kcgs_score_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chart_data.dart';
import '../models/esglab_ind_avg_score_model.dart';
import '../models/esglab_score_model.dart';
import '../models/gri_usage_ind_avg_score_model.dart';
import '../models/kcgs_ind_avg_score_model.dart';
import '../models/prism_ind_avg_score_model.dart';
import '../models/prism_score_model.dart';
import '../models/report_sentences_model.dart';
import '../models/report_table_model.dart';
import '../models/sustain_report_model.dart';
import '../services/api_services.dart';


class SecondPage extends StatefulWidget {
  final String company_name, company_industry;

  const SecondPage(
    this.company_name, this.company_industry,
    {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late String company_name, company_industry;

  late TabController _scoreTabController;

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
    super.initState();

    company_name = widget.company_name;
    company_industry = widget.company_industry;

    _scoreTabController = TabController(length: 3, vsync: this);

    fetchCompanyDetailData(company_name);
  }

  @override
  void dispose() {
    _scoreTabController.dispose();
    super.dispose();
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
  // 세부페이지 - ESG 정보 탭: gri_index에 따른 문장들
  late Map<String, List<Map<int, dynamic>>> detail_gri_sentences = {};
  // 세부페이지 - ESG 정보 탭: gri_index에 따른 표
  late Map<String, List<Map<int, dynamic>>> detail_gri_tables = {};

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
  Map<String, List<Map<int, dynamic>>> gri_sentences = {};
  Map<String, List<Map<int, dynamic>>> gri_tables = {};
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
      gri_sentences = {};
      gri_tables = {};


      // SecondPage로 보내는 데이터 처음에 초기화
      detail_info_years = [];
      detail_prism_info = {};
      detail_association_info = {};
      detail_esg_info = {};
      detail_gri_index = [];
      detail_download_links = {};
      detail_gri_sentences = {};
      detail_gri_tables = {};

      List<Map<String, dynamic>> detailPage = await ApiService.outDetailPageInfo(company_name); 
      final List<String> keys = [
        "prism_scores",
        "prism_ind_avg_scores",
        "kcgs_scores", 
        "esglab_scores",
        "kcgs_ind_avg_scores",
        "esglab_ind_avg_scores", 
        "sustain_reports", 
        "gri_info", 
        "report_sentences", 
        "report_tables", 
        "gri_usage_ind_avg_score"];

      List<PrismScoreModel> prism_scores = ApiService.outPrismScores(detailPage[0][keys[0]]);
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
      
      List<PrismIndAvgScoreModel> prism_ind_avg_scores = ApiService.outPrismIndAvgScores(detailPage[0][keys[1]]);
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

      List<KcgsScoreModel> kcgs_scores = ApiService.outKcgsScores(detailPage[0][keys[2]]);
      for (var kcgs_score in kcgs_scores) {
        k_association_info[kcgs_score.evalYear] = {
          'kcgsOverallScore': kcgs_score.overallScore,
          'kcgsEScore': kcgs_score.EScore,
          'kcgsSScore': kcgs_score.SScore,
          'kcgsGScore': kcgs_score.GScore,
        };
      }
      
      List<EsglabScoreModel> esglab_scores = ApiService.outEsglabScores(detailPage[0][keys[3]]);
      for(var esglab_score in esglab_scores) {
        el_association_info[esglab_score.evalYear] = {
          'esglabOverallScore': esglab_score.overallScore,
          'esglabEScore': esglab_score.EScore,
          'esglabSScore': esglab_score.SScore,
          'esglabGScore': esglab_score.GScore,
        };
      }
      List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = ApiService.outKcgsIndAvgScores(detailPage[0][keys[4]]);
      for (var kcgs_ind_avg_score in kcgs_ind_avg_scores) {
        k_a_association_info[kcgs_ind_avg_score.year] = {
          'kcsgAvgOverallScore': kcgs_ind_avg_score.overallScore,
          'kcsgAvgEScore': kcgs_ind_avg_score.EScore,
          'kcsgAvgSScore': kcgs_ind_avg_score.SScore,
          'kcsgAvgGScore': kcgs_ind_avg_score.GScore,
        };
      }
      List<EsglabIndAvgScoreModel> esglab_ind_avg_scores = ApiService.outEsglabIndAvgScores(detailPage[0][keys[5]]);
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

      List<SustainReportModel> sustain_reports = ApiService.outSustainReports(detailPage[0][keys[6]]);
      for(var sustain_report in sustain_reports) {
        download_links[sustain_report.year] = sustain_report.download_link;
        if (years[0] == sustain_report.year){
          esg_info = {
            'Escore': sustain_report.e_score,
            'Sscore': sustain_report.s_score,
            'Gscore': sustain_report.g_score,
          };
        }
        
      }
      
      List<GriUsageIndAvgScoreModel> gri_usage_ind_avg_scores = ApiService.outGriUsageIndAvgScores(detailPage[0][keys[10]]);
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

      List<GriInfoModel> gri_infos = ApiService.outGriInfos(detailPage[0][keys[7]]);
      for (var gri_info in gri_infos) {
        gri_index.add(gri_info.gri_index);
      }

      List<ReportSentencesModel> report_sentences = ApiService.outReportSentencess(detailPage[0][keys[8]]);
      for (var report_sentence in report_sentences) {
        if (gri_sentences.containsKey(report_sentence.gri_index)) {
          gri_sentences[report_sentence.gri_index]!.add({
            report_sentence.sim_rank: [
              report_sentence.preced_sentences,
              report_sentence.most_sentences,
              report_sentence.back_sentences
            ]
          });
        } else {
          gri_sentences[report_sentence.gri_index] = [
            {
              report_sentence.sim_rank: [
                report_sentence.preced_sentences,
                report_sentence.most_sentences,
                report_sentence.back_sentences
              ]
            }
          ];
        }
      }
      print(gri_sentences);

      List<ReportTableModel> report_tables = ApiService.outReportTables(detailPage[0][keys[9]]);
      for (var report_table in report_tables) {
        if (gri_tables.containsKey(report_table.gri_index)) {
          gri_tables[report_table.gri_index]!.add({
            report_table.sim_rank: report_table.link
            
          });
        } else {
          gri_tables[report_table.gri_index] = [
            {
              report_table.sim_rank: report_table.link
            }
          ];
        }
      }
      print(gri_tables);

      setState(() {
        detail_info_years = years;
        detail_prism_info = prism_info;
        detail_association_info = association_info;
        detail_download_links = download_links;
        detail_esg_info = esg_rates;
        detail_gri_index = gri_index;
        detail_gri_sentences = gri_sentences;
        detail_gri_tables = gri_tables;
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

  @override
  Widget build(BuildContext context) {
    print(company_name);
                              print(company_industry);
                              print(detail_info_years);
                              print(detail_download_links);
                              print(detail_prism_info);
                              print(detail_association_info);
                              print(detail_esg_info);
                              print(detail_gri_index);
                              print(detail_gri_sentences);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 기업 기본 정보
              Row(
                children: [
                  // 버튼: 랭킹 페이지로 돌아가기
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  // 기업명
                  Text(
                    company_name,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 업종
                  Text(company_industry),
                  const SizedBox(width: 20),
                  // 보고서 다운 버튼
                  Row(
                    children: List.generate(
                      detail_info_years.length,
                      (index) => Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              // 원하는 동작 수행
                              // detail_download_links
                              print(detail_download_links[detail_info_years[index]]);
                              String link;
                              if (detail_download_links[detail_info_years[index]] != null)
                                link = detail_download_links[detail_info_years[index]].toString();
                              else
                                link = "";
                              final Uri _url = Uri.parse(link);

                              if (!await launchUrl(_url)) {
                                throw Exception('Could not launch $_url');
                              }
                            },
                            icon: const Icon(Icons.book),
                          ),
                          Text(detail_info_years[index].toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 탭: 기업 세부 정보
              TabBar(
                controller: _scoreTabController,
                tabs: const [
                  Tab(text: 'PRISM 스코어'),
                  Tab(text: '평가기관 등급'),
                  Tab(text: 'ESG 정보'),
                ],
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.normal),
              ),
              Expanded(
                child: TabBarView(
                  controller: _scoreTabController,
                  children: [
                    _buildDetailScoreTab(),
                    _buildRatingTab(),
                    detail_info_years.isNotEmpty ? _buildesgInfoTab() : Center(child: Text("No Data")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  // PRISM 스코어 탭
  Widget _buildDetailScoreTab() {
    // List<int> years = [2022, 2021, 2020];
    List<int> years = detail_info_years;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // bar 그래프
          // - 그래프 색상 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color(0xff000000),'${company_name} - prsimALL'),
              _infoGraph(const Color(0xff4EA74A),'${company_name} - prismE'),
              _infoGraph(const Color(0xff5EC1F7),'${company_name} - prismS'),
              _infoGraph(const Color(0xffCE67FD),'${company_name} - prismG'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color.fromARGB(150, 0, 0, 0),'${company_industry} - prsimALL'),
              _infoGraph(const Color.fromARGB(150, 78, 167, 82),'${company_industry} - prismE'),
              _infoGraph(const Color.fromARGB(150, 94, 193, 247),'${company_industry} - prismS'),
              _infoGraph(const Color.fromARGB(150, 206, 103, 253),'${company_industry} - prismG'),
            ],
          ),
          // - 그래프 정보
          printPrismGraph(years),
          const SizedBox(height: 50),
          // 도넛 차트
          // - 그래프 색상 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color(0xff7F56D9),'${company_name}'),
              _infoGraph(const Color(0xffF0D9FF),'${company_industry}'),
            ],
          ),
          // 년도별 수치 정보
          for (int year in years)
            _prismScore(year),
        ],
      ),
    );
  }

  Padding printPrismGraph(List<int> years) {

    List<Map<String, dynamic>> dataPrismALL = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['overallScore'] != null ? detail_prism_info[years[i]]!['overallScore']: 0,
      };
      dataPrismALL.add(item);
    }

    List<Map<String, dynamic>> dataPrismE = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['EScore'] != null ? detail_prism_info[years[i]]!['EScore']: 0,
      };
      dataPrismE.add(item);
    }

    List<Map<String, dynamic>> dataPrismS = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['SScore'] != null ? detail_prism_info[years[i]]!['SScore']: 0,
      };
      dataPrismS.add(item);
    }

    List<Map<String, dynamic>> dataPrismG = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['GScore'] != null ? detail_prism_info[years[i]]!['GScore']: 0,
      };
      dataPrismG.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismALL = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['indOverallScore'] != null ? detail_prism_info[years[i]]!['indOverallScore']: 0,
      };
      dataIndPrismALL.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismE = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['indEScore'] != null ? detail_prism_info[years[i]]!['indEScore']: 0,
      };
      dataIndPrismE.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismS = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['indSScore'] != null ? detail_prism_info[years[i]]!['indSScore']: 0,
      };
      dataIndPrismS.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismG = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info[years[i]]?['indGScore'] != null ? detail_prism_info[years[i]]!['indGScore']: 0,
      };
      dataIndPrismG.add(item);
    }

    return Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const aspectRatio = 16 / 5;
              return AspectRatio(
                aspectRatio: aspectRatio,
                child: DChartBar(
                  data: [
                    {
                      'id': '${company_name} - prismALL',
                      'data': dataPrismALL,
                    },
                    {
                      'id': '${company_industry} - prismALL',
                      'data': dataIndPrismALL,
                    },
                    {
                      'id': '${company_name} - prismE',
                      'data': dataPrismE,
                    },
                    {
                      'id': '${company_industry} - prismE',
                      'data': dataIndPrismE,
                    },
                    {
                      'id': '${company_name} - prismS',
                      'data': dataPrismS,
                    },
                    {
                      'id': '${company_industry} - prismS',
                      'data': dataIndPrismS,
                    },
                    {
                      'id': '${company_name} - prismG',
                      'data': dataPrismG,
                    },
                    {
                      'id': '${company_industry} - prismG',
                      'data': dataIndPrismG,
                    },
                  ],
                  minimumPaddingBetweenLabel: 1,
                  domainLabelPaddingToAxisLine: 16,
                  domainLabelFontSize: 15,
                  axisLineTick: 2,
                  axisLinePointTick: 2,
                  axisLinePointWidth: 10,
                  measureLabelPaddingToAxisLine: 16,
                  barColor: (barData, index, id) => id ==
                          '${company_name} - prismALL'
                      ? const Color(0xff000000)
                      : id == '${company_name} - prismE'
                          ? const Color(0xff4EA74A)
                          : id == '${company_name} - prismS'
                              ? const Color(0xff5EC1F7)
                              : id == '${company_name} - prismG'
                                  ? const Color(0xffCE67FD)
                                  : id == '${company_industry} - prismALL'
                                      ? const Color.fromARGB(150, 0, 0, 0)
                                      : id == '${company_industry} - prismE'
                                          ? const Color.fromARGB(
                                              150, 78, 167, 82)
                                          : id ==
                                                  '${company_industry} - prismS'
                                              ? const Color.fromARGB(
                                                  150, 94, 193, 247)
                                              : const Color.fromARGB(
                                                  150, 206, 103, 253),
                  barValue: (barData, index) => '${barData['measure']}',
                  showBarValue: true,
                  barValueFontSize: 12,
                  barValuePosition: BarValuePosition.outside,
                  measureMin: 0,
                  measureMax: 100,
                ),
              );
            },
          ),
        );
  }
  
  // - PRISM 도넛 차트 생성 호출
  Widget _prismScore(int year) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${year.toString()} 스코어",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildDChartGauge("prism-ALL",
              detail_prism_info[year]?['overallScore'],
              detail_prism_info[year]?['indOverallScore'],
              detail_prism_info[year]?['overallRank'],
              detail_prism_info[year]?['indOverallRank'])),
              Expanded(child: _buildDChartGauge("prism-E",
              detail_prism_info[year]?['EScore'],
              detail_prism_info[year]?['indEScore'],
              detail_prism_info[year]?['Erank'],
              detail_prism_info[year]?['indERank'])),
              Expanded(child: _buildDChartGauge("prism-S",
              detail_prism_info[year]?['SScore'],
              detail_prism_info[year]?['indSScore'],
              detail_prism_info[year]?['Srank'],
              detail_prism_info[year]?['indSRank'])),
              Expanded(child: _buildDChartGauge("prism-G",
              detail_prism_info[year]?['GScore'],
              detail_prism_info[year]?['indGScore'],
              detail_prism_info[year]?['Grank'],
              detail_prism_info[year]?['indGRank'])),
            ],
          ),
        ],
      ),
    );
  }


  // 평가기관 등급 탭
  Widget _buildRatingTab() {
    List<int> years = detail_info_years;

    detail_association_info;

    List<Map<String, dynamic>> dataKcgs = [];
    for (int i = 0; i < years.length; i++) {
      var score = detail_association_info[years[i]]!['kcgsOverallScore'];
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': score != null
                  ? score == 'S' ? 100
                  : score == 'A+' ? 90
                  : score == 'A' ? 80
                  : score == 'B+' ? 70
                  : score == 'B' ? 60
                  : score == 'C' ? 50
                  : 40
                  : null, 
      };
      dataKcgs.add(item);
    }

    List<Map<String, dynamic>> dataEsglab = [];
    for (int i = 0; i < years.length; i++) {
      var score = detail_association_info[years[i]]?['esglabOverallScore'];
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': score != null
                  ? score == 'S' ? 100
                  : score == 'A+' ? 90
                  : score == 'A' ? 80
                  : score == 'B+' ? 70
                  : score == 'B' ? 60
                  : score == 'C' ? 50
                  : 40
                  : null, 
      };
      dataEsglab.add(item);
    }

    List<Map<String, dynamic>> dataIndKcgs = [];
    for (int i = 0; i < years.length; i++) {
      var score = detail_association_info[years[i]]?['kcsgAvgOverallScore'];
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': score != null
                  ? score == 'S' ? 100
                  : score == 'A+' ? 90
                  : score == 'A' ? 80
                  : score == 'B+' ? 70
                  : score == 'B' ? 60
                  : score == 'C' ? 50
                  : 40
                  : null, 
      };
      dataIndKcgs.add(item);
    }

    List<Map<String, dynamic>> dataIndEsglab = [];
    for (int i = 0; i < years.length; i++) {
      var score = detail_association_info[years[i]]?['esglabAvgOverallScore'];
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': score != null
                  ? score == 'S' ? 100
                  : score == 'A+' ? 90
                  : score == 'A' ? 80
                  : score == 'B+' ? 70
                  : score == 'B' ? 60
                  : score == 'C' ? 50
                  : 40
                  : null, 
      };
      dataIndEsglab.add(item);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16,),
          // bar 그래프
          // - 그래프 색상 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color(0xff5EC1F7),'${company_name} - KCGS'),
              _infoGraph(const Color(0xffCE67FD),'${company_name} - 한국ESG연구소'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color.fromARGB(150, 94, 193, 247),'${company_industry} - KCSG'),
              _infoGraph(const Color.fromARGB(150, 206, 103, 253),'${company_industry} - 한국ESG연구소'),
            ],
          ),
          // - 그래프 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const aspectRatio = 16 / 5;
                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: DChartBar(
                    data: [
                      {
                        'id': '${company_name} - KCGS',
                        'data': dataKcgs,
                      },
                      {
                        'id': '${company_industry} - KCGS',
                        'data': dataIndKcgs,
                      },
                      {
                        'id': '${company_name} - 한국ESG연구소',
                        'data': dataEsglab,
                      },
                      {
                        'id': '${company_industry} - 한국ESG연구소',
                        'data': dataIndEsglab,
                      },
                    ],
                    minimumPaddingBetweenLabel: 1,
                    domainLabelPaddingToAxisLine: 16,
                    domainLabelFontSize: 15,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 10,
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) =>
                        id == '${company_name} - KCGS'
                            ?  const Color(0xff5EC1F7)
                            : id == '${company_name} - 한국ESG연구소'
                                ? const Color(0xffCE67FD)
                                : id == '${company_industry} - KCGS' 
                                  ? const Color.fromARGB(150, 94, 193, 247) 
                                  : const Color.fromARGB(150, 206, 103, 253),
                    barValue: (barData, index) => barData['measure'] == 100
                        ? 'S'
                        : (barData['measure'] == 90
                            ? 'A+'
                            : (barData['measure'] == 80
                                ? 'A'
                                : (barData['measure'] == 70
                                    ? 'B+'
                                    : (barData['measure'] == 60
                                        ? 'B'
                                        : (barData['measure'] == 50
                                            ? 'C'
                                            : 'D'))))),  //40
                    showBarValue: true,
                    barValueFontSize: 12,
                    barValuePosition: BarValuePosition.outside,
                    measureMin: 0,
                    measureMax: 100,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50),
          // 표
          // - 세부정보
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('* ${company_name} / ${company_industry} 평균')
            ],
          ),
          // 년도별 수치정보
          for (int year in years)
            _rateAssociation(year),
        ],
      ),
    );
  }

  // - 표 생성
  Widget _rateAssociation(int year) {

    detail_association_info[year]?['kcgsOverallScore'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${year.toString()} 스코어",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text('기관', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('종합점수', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('E', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('G', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
            rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text('KCGS')),
                  DataCell(Text('${detail_association_info[year]?['kcgsOverallScore']} / ${detail_association_info[year]?['kcsgAvgOverallScore']}')),
                  DataCell(Text('${detail_association_info[year]?['kcgsEScore']} / ${detail_association_info[year]?['kcsgAvgEScore']}')),
                  DataCell(Text('${detail_association_info[year]?['kcgsSScore']} / ${detail_association_info[year]?['kcsgAvgSScore']}')),
                  DataCell(Text('${detail_association_info[year]?['kcgsGScore']} / ${detail_association_info[year]?['kcsgAvgGScore']}')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text('한국ESG연구소')),
                  DataCell(Text('${detail_association_info[year]?['esglabOverallScore']} / ${detail_association_info[year]?['esglabAvgOverallScore']}')),
                  DataCell(Text('${detail_association_info[year]?['esglabEScore']} / ${detail_association_info[year]?['esglabAvgEScore']}')),
                  DataCell(Text('${detail_association_info[year]?['esglabSScore']} / ${detail_association_info[year]?['esglabAvgSScore']}')),
                  DataCell(Text('${detail_association_info[year]?['esglabGScore']} / ${detail_association_info[year]?['esglabAvgGScore']}')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ESG 정보 탭
  Widget _buildesgInfoTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지속가능경영보고서 내 ESG 비율 (${detail_info_years[0]})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // 도넛 차트
          // - 그래프 색상 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _infoGraph(const Color(0xff7F56D9),'${company_name}'),
              _infoGraph(const Color(0xffF0D9FF),'${company_industry}'),
            ],
          ),
          // - 그래프 정보
          _rateESG(),
          // GRI 인덱스 정보
          ExpansionTile(
            title: const Text('E'),
            subtitle: const Text('GRI 200'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[_buildESGTab('E'),],
          ),
          ExpansionTile(
            title: const Text('S'),
            subtitle: const Text('GRI 400'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[_buildESGTab('S'),],
          ),
          ExpansionTile(
            title: const Text('G'),
            subtitle: const Text('GRI 300'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[_buildESGTab('G'),],
          ),
        ],
      ),
    );
  }

  // - ESG 도넛 차트 생성 호출
  Widget _rateESG() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildDChartGauge("E 비율", detail_esg_info['Escore'], detail_esg_info['indEscore'], 0, 0)),
        Expanded(child: _buildDChartGauge("S 비율", detail_esg_info['Sscore'], detail_esg_info['indSscore'], 0, 0)),
        Expanded(child: _buildDChartGauge("G 비율", detail_esg_info['Gscore'], detail_esg_info['indGscore'], 0, 0)),
      ],
    );
  }

  // - GRI 정보
  Widget _buildESGTab(String tab) {
    List<String> gris = [];
    for (var gri_index in detail_gri_index) {
      if (tab == "E") {
        // 200
        if (gri_index[0] == '2') {
          gris.add(gri_index);
        }
      }
      else if (tab == "S") {
        // 400
        if (gri_index[0] == '4') {
          gris.add(gri_index);
        }
      }
      else { // G
        // 300
        if (gri_index[0] == '3') {
          gris.add(gri_index);
        }
      }
    }
    // gri
    detail_gri_sentences;
    

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              for (var gri in gris)
                ExpansionTile(
                  title: Text(gri_subs.contains(gri) ? "$gri: ${gri_subs_name[gri_subs.indexOf(gri)]}" : gri),
                  //subtitle: const Text('Leading expansion arrow icon'),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (detail_gri_sentences[gri]?.length != null)...[
                            for (int i = 0; i < detail_gri_sentences[gri]!.length; i++) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(detail_gri_sentences[gri]?[i][i+1][0], style: TextStyle(color: Colors.grey)),
                                Text(detail_gri_sentences[gri]?[i][i+1][1]),
                                Text(detail_gri_sentences[gri]?[i][i+1][2], style: TextStyle(color: Colors.grey)),
                                const Divider(thickness: 1, height: 1, color: Colors.grey),
                              ],
                            ),
                          ],
                          ],
                          // 표
                          if (detail_gri_tables[gri]?.length != null)...[
                            for (int i = 0; i < detail_gri_tables[gri]!.length; i++) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  detail_gri_tables[gri]?[i][i+1],
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // 예외 처리 로직을 작성합니다.
                                    // 예를 들어, 예외 메시지를 출력하거나 기본 이미지를 보여줄 수 있습니다.
                                    print('Image loading error: $exception');
                                    return Text('Failed to load image');
                                  },
                                ),
                                const Divider(thickness: 1, height: 1, color: Colors.grey),
                              ],
                            ),
                          ],
                          ],
                          
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }


  // 그래프 색상 정보
  Row _infoGraph(Color color, String info) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
        Text(info),
      ],
    );
  }

  // 도넛 차트 생성
  Widget _buildDChartGauge(String title, int? company_score, int? industry_score, int? whole_rank, int? industry_rank) {
    if (company_score == null) company_score = -1;
    if (industry_score == null) industry_score = -1;
    if (whole_rank == null) whole_rank = -1;
    if (industry_rank == null) industry_rank = -1;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SfCircularChart(
              title: ChartTitle(text: title, textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              series: <CircularSeries>[
                RadialBarSeries<ChartData, String>(
                  dataSource: <ChartData>[
                    ChartData(company_name, company_score),
                    ChartData(company_industry, industry_score),
                  ],
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  maximumValue: 100,
                ),
              ],
              palette: const <Color>[
                Color(0xff7F56D9),
                Color(0xffF0D9FF),
              ],
            ),
            // 각 prism 스코어 값
            Text("$company_score", style: const TextStyle(color: Color(0xff101828), fontSize: 30, fontWeight: FontWeight.bold)),
            Text("업계 평균 $industry_score", style: const TextStyle(color: Color(0xff667085))),
            if(industry_rank != 0 && industry_rank != -1) ...[Text("업계 내 $industry_rank위", style: const TextStyle(color: Color(0xff667085)))],
            if(whole_rank != 0 && whole_rank != -1) ...[Text("전체 $whole_rank위", style: const TextStyle(color: Color(0xff667085)))],
          ],
        ),
      ),
    );
  }

}
