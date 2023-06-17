import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final String companyName;

  const SecondPage(this.companyName, {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late String companyName;

  late TabController _scoreTabController;
  late TabController _yearTabController;
  late TabController _detailScoreTabController;
  late TabController _esgTabController;

  @override
  void initState() {
    super.initState();

    companyName = widget.companyName;

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
              Text(
                companyName,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
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
          child: Text('연도별 점수 추이 ($year)'),
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
              const Text('ESG 비율'),
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
                    data: const [
                      {
                        'id': 'Line',
                        'data': [
                          {'domain': 0, 'measure': 4.1},
                          {'domain': 1, 'measure': 4.5},
                          {'domain': 2, 'measure': 6},
                          {'domain': 3, 'measure': 3.8},
                          {'domain': 4, 'measure': 2.5},
                        ],
                      },
                    ],
                    lineColor: (lineData, index, id) => Colors.amber,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildESGTab(String tab) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('$tab 탭 설명'),
          // 여기에 ExpansionTile 위젯 추가
          const Column(
            children: [
              ExpansionTile(
                title: Text('ExpansionTile 3'),
                subtitle: Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  ListTile(title: Text('This is tile number 3')),
                ],
              ),
              ExpansionTile(
                title: Text('ExpansionTile 3'),
                subtitle: Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  ListTile(title: Text('This is tile number 3')),
                ],
              ),
              ExpansionTile(
                title: Text('ExpansionTile 3'),
                subtitle: Text('Leading expansion arrow icon'),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
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
        child: FractionallySizedBox(
          widthFactor: 1 / width, //0.25,
          child: AspectRatio(
            aspectRatio: 1,
            child: DChartGauge(
              data: const [
                {'domain': 'Off', 'measure': 30},
                {'domain': 'Warm', 'measure': 30},
                {'domain': 'Hot', 'measure': 30},
              ],
              fillColor: (pieData, index) {
                switch (pieData['domain']) {
                  case 'Off':
                    return Colors.green;
                  case 'Warm':
                    return Colors.orange;
                  default:
                    return Colors.red;
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
      ),
    );
  }

  Widget _buildRatingTab() {
    return const Center(
      child: Text('평가기관 등급 탭'),
    );
  }
}
