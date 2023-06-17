import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

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

    _scoreTabController = TabController(length: 2, vsync: this);
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
                    _buildPRISMScoreTab(),
                    _buildRatingTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPRISMScoreTab() {
    return Column(
      children: [
        TabBar(
          controller: _yearTabController,
          tabs: const [
            Tab(text: '2020년'),
            Tab(text: '2021년'),
            Tab(text: '2022년'),
          ],
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: TabBarView(
            controller: _yearTabController,
            children: [
              _buildYearTab('2020년'),
              _buildYearTab('2021년'),
              _buildYearTab('2022년'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYearTab(String year) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Text(
            '연도별 점수 추이 ($year)',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SliverToBoxAdapter(
          child: TabBar(
            controller: _detailScoreTabController,
            tabs: const [
              Tab(text: 'prism-ALL'),
              Tab(text: 'prism-E'),
              Tab(text: 'prism-S'),
              Tab(text: 'prism-G'),
            ],
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TabBarView(
                  controller: _detailScoreTabController,
                  children: [
                    _buildDetailScoreTab('prism-ALL'),
                    _buildDetailScoreTab('prism-E'),
                    _buildDetailScoreTab('prism-S'),
                    _buildDetailScoreTab('prism-G'),
                  ],
                ),
              ),
              _prismScore(),
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
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.normal),
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
          ),
        ),
      ],
    );
  }

  Widget _buildDetailScoreTab(String tab) {
    return Column(
      children: [
        Text('$tab 탭 설명'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio =
                    constraints.maxWidth / constraints.maxHeight;
                return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: DChartLine(
                      data: [
                        {
                          'id': company.name,
                          'data': const [
                            {'domain': 0, 'measure': 30},
                            {'domain': 1, 'measure': 40},
                            {'domain': 2, 'measure': 40},
                          ],
                        },
                        {
                          'id': company.industry,
                          'data': const [
                            {'domain': 0, 'measure': 50},
                            {'domain': 1, 'measure': 60},
                            {'domain': 2, 'measure': 65},
                          ],
                        },
                      ],
                      lineColor: (lineData, index, id) => Colors.amber,
                      includePoints: true,
                    ));
              },
            ),
          ),
        ),
      ],
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

  Widget _prismScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildDChartGauge(4, 5)),
        Expanded(child: _buildDChartGauge(4, 5)),
        Expanded(child: _buildDChartGauge(4, 5)),
        Expanded(child: _buildDChartGauge(4, 5)),
      ],
    );
  }

  Widget _rateESG() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildDChartGauge(3, 5)),
        Expanded(child: _buildDChartGauge(3, 5)),
        Expanded(child: _buildDChartGauge(3, 5)),
      ],
    );
  }

  Widget _buildDChartGauge(int width, int height) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("prism-ALL"),
            FractionallySizedBox(
              widthFactor: 1 / width, //0.25,
              child: AspectRatio(
                aspectRatio: 1,
                child: DChartGauge(
                  data: const [
                    {'domain': '', 'measure': 40},
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case '':
                        return Colors.purple;
                    }
                  },
                  showLabelLine: false,
                  pieLabel: (pieData, index) {
                    return "${pieData['domain']}";
                  },
                  labelPosition: PieLabelPosition.inside,
                  labelPadding: 0,
                  labelColor: Colors.white,
                ),
              ),
            ),
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
    return const Center(
      child: Text('평가기관 등급 탭'),
    );
  }
}
