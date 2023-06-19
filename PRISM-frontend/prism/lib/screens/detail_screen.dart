import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_data.dart';
import 'home_screen.dart';


class SecondPage extends StatefulWidget {
  final String company_name, company_industry;

  const SecondPage(this.company_name, this.company_industry, {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late String company_name, company_industry;

  late TabController _scoreTabController;

  @override
  void initState() {
    super.initState();

    company_name = widget.company_name;
    company_industry = widget.company_industry;

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
  late List<KcgsScoreModel> kcgs_scores;
  late List<EsglabScoreModel> esglab_scores;
  late List<SustainReportModel> sustain_reports;
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
                    //company.name,
                    company_name,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 업종
                  Text(company_industry.toString()
                    // company.industry
                  ),
                  const SizedBox(width: 20),
                  // 보고서 다운 버튼
                  Column(
                    children: [
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(Icons.book),
                      ),
                      const Text("2020"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(Icons.book),
                      ),
                      const Text("2021"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(Icons.book),
                      ),
                      const Text("2022"),
                    ],
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
                    _buildesgInfoTab(),
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
    List<int> years = [2022, 2021, 2020];

    return SingleChildScrollView(
      child: Column(
        children: [
          // const Text(
          //   "스코어 추이 그래프",
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const SizedBox(height: 16),
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
        'domain': years[i],
        'measure': years[i] * years[i],
      };
      dataPrismALL.add(item);
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
                      'data': const [
                        {'domain': '2020', 'measure': 32},
                        {'domain': '2021', 'measure': 43},
                        {'domain': '2022', 'measure': 29},
                      ],
                    },
                    {
                      'id': '${company_industry} - prismALL',
                      'data': const [
                        {'domain': '2020', 'measure': 57},
                        {'domain': '2021', 'measure': 58},
                        {'domain': '2022', 'measure': 52},
                      ],
                    },
                    {
                      'id': '${company_name} - prismE',
                      'data': const [
                        {'domain': '2020', 'measure': 24},
                        {'domain': '2021', 'measure': 42},
                        {'domain': '2022', 'measure': 9},
                      ],
                    },
                    {
                      'id': '${company_industry} - prismE',
                      'data': const [
                        {'domain': '2020', 'measure': 87},
                        {'domain': '2021', 'measure': 88},
                        {'domain': '2022', 'measure': 82},
                      ],
                    },
                    {
                      'id': '${company_name} - prismS',
                      'data': const [
                        {'domain': '2020', 'measure': 17},
                        {'domain': '2021', 'measure': 28},
                        {'domain': '2022', 'measure': 12},
                      ],
                    },
                    {
                      'id': '${company_industry} - prismS',
                      'data': const [
                        {'domain': '2020', 'measure': 7},
                        {'domain': '2021', 'measure': 8},
                        {'domain': '2022', 'measure': 2},
                      ],
                    },
                    {
                      'id': '${company_name} - prismG',
                      'data': const [
                        {'domain': '2020', 'measure': 17},
                        {'domain': '2021', 'measure': 28},
                        {'domain': '2022', 'measure': 12},
                      ],
                    },
                    {
                      'id': '${company_industry} - prismG',
                      'data': const [
                        {'domain': '2020', 'measure': 17},
                        {'domain': '2021', 'measure': 28},
                        {'domain': '2022', 'measure': 12},
                      ],
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
              Expanded(child: _buildDChartGauge("prism-ALL")),
              Expanded(child: _buildDChartGauge("prism-E")),
              Expanded(child: _buildDChartGauge("prism-S")),
              Expanded(child: _buildDChartGauge("prism-G")),
            ],
          ),
        ],
      ),
    );
  }


  // 평가기관 등급 탭
  Widget _buildRatingTab() {
    List<int> years = [2022, 2021, 2020];

    return SingleChildScrollView(
      child: Column(
        children: [
          // const Text(
          //   "스코어 추이 그래프",
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
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
                        'data': const [
                          {'domain': '2020', 'measure': 100},
                          {'domain': '2021', 'measure': 90},
                          {'domain': '2022', 'measure': 90},
                        ],
                      },
                      {
                        'id': '${company_industry} - KCGS',
                        'data': const [
                          {'domain': '2020', 'measure': 50},
                          {'domain': '2021', 'measure': 60},
                          {'domain': '2022', 'measure': 70},
                        ],
                      },
                      {
                        'id': '${company_name} - 한국ESG연구소',
                        'data': const [
                          {'domain': '2020', 'measure': 80},
                          {'domain': '2021', 'measure': 90},
                          {'domain': '2022', 'measure': 70},
                        ],
                      },
                      {
                        'id': '${company_industry} - 한국ESG연구소',
                        'data': const [
                          {'domain': '2020', 'measure': 50},
                          {'domain': '2021', 'measure': 60},
                          {'domain': '2022', 'measure': 70},
                        ],
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
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('KCGS')),
                  DataCell(Text('A+ / B+')),
                  DataCell(Text('A+ / B+')),
                  DataCell(Text('A / B')),
                  DataCell(Text('A+ / B+')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('한국ESG연구소')),
                  DataCell(Text('B+ / B+')),
                  DataCell(Text('A+ / B+')),
                  DataCell(Text('A / B')),
                  DataCell(Text('A+ / B+')),
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
          const Text(
            '지속가능경영보고서 내 ESG 비율 (2022)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        Expanded(child: _buildDChartGauge("E 비율")),
        Expanded(child: _buildDChartGauge("S 비율")),
        Expanded(child: _buildDChartGauge("G 비율")),
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
  Widget _buildDChartGauge(String title) {
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
                    ChartData(company_name, 40),
                    ChartData(company_industry.toString(), 65),
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
            const Text("40", style: TextStyle(color: Color(0xff101828), fontSize: 30, fontWeight: FontWeight.bold)),
            const Text("업계 평균 65", style: TextStyle(color: Color(0xff667085))),
            const Text("업계 152위", style: TextStyle(color: Color(0xff667085))),
            const Text("전체 152위", style: TextStyle(color: Color(0xff667085))),
          ],
        ),
      ),
    );
  }

}
