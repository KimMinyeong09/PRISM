import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_data.dart';
import 'home_screen.dart';

class SecondPage extends StatefulWidget {
  final Company company;

  const SecondPage(this.company, {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late Company company;

  late TabController _scoreTabController;
  late TabController _yearTabController;
  late TabController _detailScoreTabController;
  late TabController _esgTabController;

  @override
  void initState() {
    super.initState();

    company = widget.company;

    _scoreTabController = TabController(length: 3, vsync: this);
    _yearTabController = TabController(length: 3, vsync: this);
    _detailScoreTabController = TabController(length: 4, vsync: this);
    _esgTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _scoreTabController.dispose();
    _yearTabController.dispose();
    _detailScoreTabController.dispose();
    _esgTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(company.industry),
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
                    //_buildPRISMScoreTab(),
                    _buildDetailScoreTab(""),
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

  // Widget _buildPRISMScoreTab() {
  //   return Column(
  //     children: [
  //       TabBar(
  //         controller: _yearTabController,
  //         tabs: const [
  //           Tab(text: '2020년'),
  //           Tab(text: '2021년'),
  //           Tab(text: '2022년'),
  //         ],
  //         indicatorColor: Colors.black,
  //         labelColor: Colors.black,
  //         labelStyle: const TextStyle(fontWeight: FontWeight.bold),
  //         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
  //       ),
  //       Expanded(
  //         child: TabBarView(
  //           controller: _yearTabController,
  //           children: [
  //             _buildYearTab('2020년'),
  //             _buildYearTab('2021년'),
  //             _buildYearTab('2022년'),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildYearTab(String year) {
  //   return CustomScrollView(
  //     slivers: [
  //       SliverToBoxAdapter(
  //         child: Text(
  //           '연도별 점수 추이 ($year)',
  //           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       SliverToBoxAdapter(
  //         child: Column(
  //           children: [
  //             TabBar(
  //               controller: _detailScoreTabController,
  //               tabs: const [
  //                 Tab(text: 'prism-ALL'),
  //                 Tab(text: 'prism-E'),
  //                 Tab(text: 'prism-S'),
  //                 Tab(text: 'prism-G'),
  //               ],
  //               indicatorColor: Colors.black,
  //               labelColor: Colors.black,
  //               labelStyle: const TextStyle(fontWeight: FontWeight.bold),
  //               unselectedLabelStyle:
  //                   const TextStyle(fontWeight: FontWeight.normal),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SliverFillRemaining(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: TabBarView(
  //                 controller: _detailScoreTabController,
  //                 children: [
  //                   _buildDetailScoreTab('prism-ALL'),
  //                   _buildDetailScoreTab('prism-E'),
  //                   _buildDetailScoreTab('prism-S'),
  //                   _buildDetailScoreTab('prism-G'),
  //                 ],
  //               ),
  //             ),
  //             _prismScore(2020),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDetailScoreTab(String tab) {
  //   return Column(
  //     children: [
  //       const Text("스코어 추이 그래프",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           )),
  //       Expanded(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: LayoutBuilder(
  //             builder: (context, constraints) {
  //               final aspectRatio =
  //                   constraints.maxWidth / constraints.maxHeight;
  //               return AspectRatio(
  //                 aspectRatio: aspectRatio,
  //                 child: DChartBar(
  //                   data: [
  //                     {
  //                       'id': '${company.name} - prismALL',
  //                       'data': [
  //                         {'domain': '${company.name} 2020', 'measure': 32},
  //                         {'domain': '2021', 'measure': 43},
  //                         {'domain': '${company.name} 2022', 'measure': 29},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.name} - prismE',
  //                       'data': [
  //                         {'domain': '${company.name} 2020', 'measure': 24},
  //                         {'domain': '2021', 'measure': 42},
  //                         {'domain': '${company.name} 2022', 'measure': 9},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.name} - prismS',
  //                       'data': [
  //                         {'domain': '${company.name} 2020', 'measure': 17},
  //                         {'domain': '2021', 'measure': 28},
  //                         {'domain': '${company.name} 2022', 'measure': 12},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.name} - prismG',
  //                       'data': [
  //                         {'domain': '${company.name} 2020', 'measure': 17},
  //                         {'domain': '2021', 'measure': 28},
  //                         {'domain': '${company.name} 2022', 'measure': 12},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.industry} - prismALL',
  //                       'data': [
  //                         {'domain': '${company.industry} 2020', 'measure': 57},
  //                         {'domain': '${company.industry} 2021', 'measure': 58},
  //                         {'domain': '${company.industry} 2022', 'measure': 52},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.industry} - prismE',
  //                       'data': [
  //                         {'domain': '${company.industry} 2020', 'measure': 87},
  //                         {'domain': '${company.industry} 2021', 'measure': 88},
  //                         {'domain': '${company.industry} 2022', 'measure': 82},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.industry} - prismS',
  //                       'data': [
  //                         {'domain': '${company.industry} 2020', 'measure': 7},
  //                         {'domain': '${company.industry} 2021', 'measure': 8},
  //                         {'domain': '${company.industry} 2022', 'measure': 2},
  //                       ],
  //                     },
  //                     {
  //                       'id': '${company.industry} - prismG',
  //                       'data': [
  //                         {'domain': '${company.industry} 2020', 'measure': 17},
  //                         {'domain': '${company.industry} 2021', 'measure': 28},
  //                         {'domain': '${company.industry} 2022', 'measure': 12},
  //                       ],
  //                     },
  //                   ],
  //                   minimumPaddingBetweenLabel: 1,
  //                   domainLabelPaddingToAxisLine: 16,
  //                   axisLineTick: 2,
  //                   axisLinePointTick: 2,
  //                   axisLinePointWidth: 10,
  //                   axisLineColor: Colors.green,
  //                   measureLabelPaddingToAxisLine: 16,
  //                   barColor: (barData, index, id) =>
  //                       id == '${company.name} - prismALL'
  //                           ? Colors.green.shade300
  //                           : id == '${company.name} - prismE'
  //                               ? Colors.green.shade600
  //                               : Colors.green.shade900,
  //                   barValue: (barData, index) => '${barData['measure']}',
  //                   showBarValue: true,
  //                   barValueFontSize: 12,
  //                   barValuePosition: BarValuePosition.outside,
  //                 ),
  //               );
  //               // child: DChartLine(
  //               //   data: [
  //               //     {
  //               //       'id': company.name,
  //               //       'data': const [
  //               //         {'domain': 0, 'measure': 30},
  //               //         {'domain': 1, 'measure': 40},
  //               //         {'domain': 2, 'measure': 40},
  //               //       ],
  //               //     },
  //               //     {
  //               //       'id': company.industry,
  //               //       'data': const [
  //               //         {'domain': 0, 'measure': 50},
  //               //         {'domain': 1, 'measure': 60},
  //               //         {'domain': 2, 'measure': 65},
  //               //       ],
  //               //     },
  //               //   ],
  //               //   lineColor: (lineData, index, id) => Colors.amber,
  //               //   includePoints: true,
  //               // ));
  //             },
  //           ),
  //         ),
  //       ),
  //       _prismScore(2020),
  //       _prismScore(2021),
  //       _prismScore(2022),
  //     ],
  //   );
  // }

  Widget _buildDetailScoreTab(String tab) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "스코어 추이 그래프",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xff000000),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.name} - prsimALL'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xff4EA74A),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.name} - prismE'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xff5EC1F7),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.name} - prismS'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color(0xffCE67FD),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.name} - prismG'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color.fromARGB(150, 0, 0, 0),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.industry} - prsimALL'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color.fromARGB(150, 78, 167, 82),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.industry} - prismE'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color.fromARGB(150, 94, 193, 247),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.industry} - prismS'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    color: const Color.fromARGB(150, 206, 103, 253),
                  ),
                  const SizedBox(width: 8), // 사각형과 텍스트 사이의 간격 조정
                  Text('${company.industry} - prismG'),
                ],
              ),
            ],
          ),
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
                        'id': '${company.name} - prismALL',
                        'data': const [
                          {'domain': '2020', 'measure': 32},
                          {'domain': '2021', 'measure': 43},
                          {'domain': '2022', 'measure': 29},
                        ],
                      },
                      {
                        'id': '${company.industry} - prismALL',
                        'data': const [
                          {'domain': '2020', 'measure': 57},
                          {'domain': '2021', 'measure': 58},
                          {'domain': '2022', 'measure': 52},
                        ],
                      },
                      {
                        'id': '${company.name} - prismE',
                        'data': const [
                          {'domain': '2020', 'measure': 24},
                          {'domain': '2021', 'measure': 42},
                          {'domain': '2022', 'measure': 9},
                        ],
                      },
                      {
                        'id': '${company.industry} - prismE',
                        'data': const [
                          {'domain': '2020', 'measure': 87},
                          {'domain': '2021', 'measure': 88},
                          {'domain': '2022', 'measure': 82},
                        ],
                      },
                      {
                        'id': '${company.name} - prismS',
                        'data': const [
                          {'domain': '2020', 'measure': 17},
                          {'domain': '2021', 'measure': 28},
                          {'domain': '2022', 'measure': 12},
                        ],
                      },
                      {
                        'id': '${company.industry} - prismS',
                        'data': const [
                          {'domain': '2020', 'measure': 7},
                          {'domain': '2021', 'measure': 8},
                          {'domain': '2022', 'measure': 2},
                        ],
                      },
                      {
                        'id': '${company.name} - prismG',
                        'data': const [
                          {'domain': '2020', 'measure': 17},
                          {'domain': '2021', 'measure': 28},
                          {'domain': '2022', 'measure': 12},
                        ],
                      },
                      {
                        'id': '${company.industry} - prismG',
                        'data': const [
                          {'domain': '2020', 'measure': 17},
                          {'domain': '2021', 'measure': 28},
                          {'domain': '2022', 'measure': 12},
                        ],
                      },
                    ],
                    minimumPaddingBetweenLabel: 1,
                    domainLabelPaddingToAxisLine: 16,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 10,
                    axisLineColor: Colors.green,
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) => id ==
                            '${company.name} - prismALL'
                        ? const Color(0xff000000)
                        : id == '${company.name} - prismE'
                            ? const Color(0xff4EA74A)
                            : id == '${company.name} - prismS'
                                ? const Color(0xff5EC1F7)
                                : id == '${company.name} - prismG'
                                    ? const Color(0xffCE67FD)
                                    : id == '${company.industry} - prismALL'
                                        ? const Color.fromARGB(150, 0, 0, 0)
                                        : id == '${company.industry} - prismE'
                                            ? const Color.fromARGB(
                                                150, 78, 167, 82)
                                            : id ==
                                                    '${company.industry} - prismS'
                                                ? const Color.fromARGB(
                                                    150, 94, 193, 247)
                                                : const Color.fromARGB(
                                                    150, 206, 103, 253),
                    barValue: (barData, index) => '${barData['measure']}',
                    showBarValue: true,
                    barValueFontSize: 12,
                    barValuePosition: BarValuePosition.outside,
                  ),
                );
              },
            ),
          ),
          _prismScore(2022),
          _prismScore(2021),
          _prismScore(2020),
        ],
      ),
    );
  }

  Widget _buildESGTab(String tab) {
    String gri = "GRI 300";
    if (tab == "E") {
      gri = "GRI 200";
    } else if (tab == "S") {
      gri = "GRI 400";
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // 여기에 ExpansionTile 위젯 추가
          Column(
            children: [
              ExpansionTile(
                title: Text(gri),
                //subtitle: const Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  ListTile(
                      title: Column(
                    children: [
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Text('핵심 문장입니다.'),
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Text('핵심 문장입니다.'),
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Text('핵심 문장입니다.'),
                      const Text('한 문장, 두 문장입니다.',
                          style: TextStyle(color: Colors.grey)),
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Age',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Role',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
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
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Age',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Role',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
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
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Age',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Role',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
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
                      const Divider(
                          thickness: 1, height: 1, color: Colors.grey),
                    ],
                  )),
                ],
              ),
              ExpansionTile(
                title: Text(gri),
                //subtitle: const Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: const <Widget>[
                  ListTile(title: Text('This is tile number 3')),
                ],
              ),
              ExpansionTile(
                title: Text(gri),
                //subtitle: const Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: const <Widget>[
                  ListTile(title: Text('This is tile number 3')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prismScore(int year) {
    return Column(
      children: [
        Text("${year.toString()} 스코어"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildDChartGauge(4, 5, "prism-ALL")),
            Expanded(child: _buildDChartGauge(4, 5, "prism-E")),
            Expanded(child: _buildDChartGauge(4, 5, "prism-S")),
            Expanded(child: _buildDChartGauge(4, 5, "prism-G")),
          ],
        ),
      ],
    );
  }

  Widget _rateESG() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildDChartGauge(3, 5, "E 비율")),
        Expanded(child: _buildDChartGauge(3, 5, "S 비율")),
        Expanded(child: _buildDChartGauge(3, 5, "G 비율")),
      ],
    );
  }

  Widget _buildDChartGauge(int width, int height, String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Text(title),
            SfCircularChart(
              series: <CircularSeries>[
                RadialBarSeries<ChartData, String>(
                  dataSource: <ChartData>[
                    ChartData(company.name, 40),
                    ChartData(company.industry, 65),
                  ],
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                ),
              ],
              palette: const <Color>[
                Color(0xff7F56D9),
                Color(0xffF0D9FF),
              ],
              title: ChartTitle(text: title),
              legend: Legend(isVisible: true),
            ),
            // FractionallySizedBox(
            //   widthFactor: 1 / width, //0.25,
            //   child: AspectRatio(
            //     aspectRatio: 1,
            //     child: DChartGauge(
            //       strokeWidth: 0.1,
            //       data: const [
            //         {'domain': 'company', 'measure': 40},
            //         {'domain': 'industry', 'measure': 65},
            //       ],
            //       fillColor: (pieData, index) {
            //         switch (pieData['domain']) {
            //           case 'company':
            //             return Colors.purple;
            //           default:
            //             return Colors.grey;
            //         }
            //       },
            //       showLabelLine: false,
            //       pieLabel: (pieData, index) {
            //         return "${pieData['domain']}";
            //       },
            //       labelPosition: PieLabelPosition.inside,
            //       labelPadding: 0,
            //       labelColor: Colors.white,
            //     ),
            //   ),
            // ),
            const Text("40"),
            const Text("업계 평균 65"),
            const Text("업계 152위"),
            const Text("전체 152위"),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "스코어 추이 그래프",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                        'id': '${company.name} - KCGS',
                        'data': [
                          {'domain': '${company.name} 2020', 'measure': 100},
                          const {'domain': '2021', 'measure': 90},
                          {'domain': '${company.name} 2022', 'measure': 90},
                        ],
                      },
                      {
                        'id': '${company.name} - 한국ESG연구소',
                        'data': [
                          {'domain': '${company.name} 2020', 'measure': 80},
                          const {'domain': '2021', 'measure': 90},
                          {'domain': '${company.name} 2022', 'measure': 70},
                        ],
                      },
                      {
                        'id': '${company.industry} - KCGS',
                        'data': [
                          {'domain': '${company.industry} 2020', 'measure': 50},
                          {'domain': '${company.industry} 2021', 'measure': 60},
                          {'domain': '${company.industry} 2022', 'measure': 70},
                        ],
                      },
                      {
                        'id': '${company.industry} - 한국ESG연구소',
                        'data': [
                          {'domain': '${company.industry} 2020', 'measure': 50},
                          {'domain': '${company.industry} 2021', 'measure': 60},
                          {'domain': '${company.industry} 2022', 'measure': 70},
                        ],
                      },
                    ],
                    minimumPaddingBetweenLabel: 1,
                    domainLabelPaddingToAxisLine: 16,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 10,
                    axisLineColor: Colors.green,
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) =>
                        id == '${company.name} - KCGS'
                            ? Colors.green.shade300
                            : id == '${company.name} - 한국ESG연구소'
                                ? Colors.green.shade600
                                : Colors.green.shade900,
                    //barValue: (barData, index) => '${barData['measure']}',
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
                                            : 'D'))))),
                    showBarValue: true,
                    barValueFontSize: 12,
                    barValuePosition: BarValuePosition.outside,
                  ),
                );
              },
            ),
          ),
          _rateAssociation(2022),
          _rateAssociation(2021),
          _rateAssociation(2020),
        ],
      ),
    );
  }

  Widget _rateAssociation(int year) {
    return Column(
      children: [
        Text("${year.toString()} 스코어"),
        DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  '기관',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  '종합점수',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'E',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'S',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'G',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('KCGS')),
                DataCell(Text('A+/B+')),
                DataCell(Text('A+/B+')),
                DataCell(Text('A/B')),
                DataCell(Text('A+/B+')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('한국ESG연구소')),
                DataCell(Text('B+/B+')),
                DataCell(Text('A+/B+')),
                DataCell(Text('A/B')),
                DataCell(Text('A+/B+')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildesgInfoTab() {
    return Column(
      children: [
        const Text(
          'ESG 비율',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _rateESG(),
        TabBar(
          controller: _esgTabController,
          tabs: const [
            Tab(text: 'E'),
            Tab(text: 'S'),
            Tab(text: 'G'),
          ],
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: TabBarView(
            controller: _esgTabController,
            children: [
              _buildESGTab('E'),
              _buildESGTab('S'),
              _buildESGTab('G'),
            ],
          ),
        ),
      ],
    );
  }
}
