import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_data.dart';
import 'home_screen.dart';


class SecondPage extends StatefulWidget {
  final String company_name, company_industry;
  final List<int> detail_info_years;
  final Map<int, Map<String, dynamic>> detail_prism_info, detail_association_info;
  final Map<int, String> detail_download_links;
  final Map<String, dynamic> detail_esg_info ;

  const SecondPage(
    this.company_name, this.company_industry,
    this.detail_info_years,
    this.detail_prism_info,
    this.detail_association_info,
    this.detail_download_links,
    this.detail_esg_info,
    {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late String company_name, company_industry;
  late List<int> detail_info_years;
  late Map<int, Map<String, dynamic>> detail_prism_info, detail_association_info;
  late Map<int, String> detail_download_links;
  late Map<String, dynamic> detail_esg_info ;

  late TabController _scoreTabController;

  @override
  void initState() {
    super.initState();

    company_name = widget.company_name;
    company_industry = widget.company_industry;
    detail_info_years = widget.detail_info_years;
    detail_prism_info = widget.detail_prism_info;
    detail_association_info = widget.detail_association_info;
    detail_download_links = widget.detail_download_links;
    detail_esg_info = widget.detail_esg_info;

    _scoreTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _scoreTabController.dispose();
    super.dispose();
  }

  // API- 회사 정보 저장 (하드코딩)
  late List<PrismScore> prism_scores;
  late List<PrismIndAvgScore> prism_ind_avg_scores;
  late List<KcgsScore> kcgs_scores;
  late List<EsglabScore> esglab_scores;
  late List<SustainReport> sustain_reports;
  late List<ReportSentencesModel> gri_infos;
  late List<ReportTableModel> report_tables;

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () {
                              // 원하는 동작 수행
                              // detail_download_links
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
        'measure': detail_prism_info?[years[i]]?['overallScore'] != null ? detail_prism_info?[years[i]]?['overallScore']: 0,
      };
      dataPrismALL.add(item);
    }

    List<Map<String, dynamic>> dataPrismE = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['EScore'] != null ? detail_prism_info?[years[i]]?['EScore']: 0,
      };
      dataPrismE.add(item);
    }

    List<Map<String, dynamic>> dataPrismS = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['SScore'] != null ? detail_prism_info?[years[i]]?['SScore']: 0,
      };
      dataPrismS.add(item);
    }

    List<Map<String, dynamic>> dataPrismG = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['GScore'] != null ? detail_prism_info?[years[i]]?['GScore']: 0,
      };
      dataPrismG.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismALL = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['indOverallScore'] != null ? detail_prism_info?[years[i]]?['indOverallScore']: 0,
      };
      dataIndPrismALL.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismE = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['indEScore'] != null ? detail_prism_info?[years[i]]?['indEScore']: 0,
      };
      dataIndPrismE.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismS = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['indSScore'] != null ? detail_prism_info?[years[i]]?['indSScore']: 0,
      };
      dataIndPrismS.add(item);
    }

    List<Map<String, dynamic>> dataIndPrismG = [];
    for (int i = 0; i < years.length; i++) {
      Map<String, dynamic> item = {
        'domain': years[i].toString(),
        'measure': detail_prism_info?[years[i]]?['indGScore'] != null ? detail_prism_info?[years[i]]?['indGScore']: 0,
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
    // List<int> years = [2022, 2021, 2020];
    List<int> years = detail_info_years;

    detail_association_info;

    List<Map<String, dynamic>> dataKcgs = [];
    for (int i = 0; i < years.length; i++) {
      var score = detail_association_info?[years[i]]?['kcgsOverallScore'];
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
      var score = detail_association_info?[years[i]]?['esglabOverallScore'];
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
      var score = detail_association_info?[years[i]]?['kcsgAvgOverallScore'];
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
      var score = detail_association_info?[years[i]]?['esglabAvgOverallScore'];
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
    List<String> gris = ["301-1", "301-2"];
    if (tab == "E") {
      gris = ["201-1", "201-2"];
    } else if (tab == "S") {
      gris = ["401-1", "401-2"];
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              for (var gri in gris)
                ExpansionTile(
                  title: Text(gri),
                  //subtitle: const Text('Leading expansion arrow icon'),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 텍스트
                          const Text('한 문장, 두 문장입니다.', style: TextStyle(color: Colors.grey)),
                          const Text('핵심 문장입니다.'),
                          const Text('한 문장, 두 문장입니다.', style: TextStyle(color: Colors.grey)),
                          const Divider(thickness: 1, height: 1, color: Colors.grey),
                          const Text('한 문장, 두 문장입니다.',style: TextStyle(color: Colors.grey)),
                          const Text('핵심 문장입니다.'),
                          const Text('한 문장, 두 문장입니다.',style: TextStyle(color: Colors.grey)),
                          const Divider(thickness: 1, height: 1, color: Colors.grey),
                          const Text('한 문장, 두 문장입니다.',style: TextStyle(color: Colors.grey)),
                          const Text('핵심 문장입니다.'),
                          const Text('한 문장, 두 문장입니다.',style: TextStyle(color: Colors.grey)),
                          const Divider(thickness: 1, height: 1, color: Colors.grey),
                          
                          // 표
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
                          const Divider(thickness: 1, height: 1, color: Colors.grey),
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
                          const Divider(thickness: 1, height: 1, color: Colors.grey),                      
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
                          const Divider(thickness: 1, height: 1, color: Colors.grey),
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
            if(industry_rank == 0) ...[Text("업계 내 $industry_rank위", style: const TextStyle(color: Color(0xff667085)))],
            if(whole_rank == 0) ...[Text("전체 $whole_rank위", style: const TextStyle(color: Color(0xff667085)))],
          ],
        ),
      ),
    );
  }

}
