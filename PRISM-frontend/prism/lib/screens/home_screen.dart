import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:prism/screens/detail_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_data.dart';

class Company {
  final int companyId;
  final String name;
  final String industry;

  Company({
    required this.companyId,
    required this.name,
    required this.industry,
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

  // API- 회사 정보 저장
  List<Company> company_list = [
    Company(companyId: 1, name: 'Company A', industry: '에너지장비및서비스'),
    Company(companyId: 2, name: 'Company B', industry: '석유와가스'),
    Company(companyId: 3, name: 'Company C', industry: '에너지장비및서비스'),
    Company(companyId: 4, name: 'Company D', industry: '에너지장비및서비스'),
    Company(companyId: 5, name: 'Company E', industry: '건축자재'),
    Company(companyId: 6, name: 'Company F', industry: '에너지장비및서비스'),
    Company(companyId: 7, name: 'Company C', industry: '복합기업'),
    Company(companyId: 8, name: 'Company G', industry: '에너지장비및서비스'),
    Company(companyId: 9, name: 'Company H', industry: '석유와가스'),
    Company(companyId: 10, name: 'Company I', industry: '복합기업'),
    Company(companyId: 11, name: 'Company J', industry: '복합기업'),
  ];

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
  List<String> gris = [
    "201-1",
    "202-2",
  ];

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
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle:
                              const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tab_controller,
                            children: [
                              rankingTab(context, "prism-ALL"),
                              rankingTab(context, "prism-E"),
                              rankingTab(context, "prism-S"),
                              rankingTab(context, "prism-G"),
                              rankingTab(context, "Wprism-ALL"),
                              rankingTab(context, "Wprism-E"),
                              rankingTab(context, "Wprism-S"),
                              rankingTab(context, "Wprism-G"),
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
                      children: [
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
                              children: List.generate(comparing_items.length,
                                  (index) {
                                String item = comparing_items[index];
                                List<String> splitText = item.split("\n");
                                String companyName = splitText[0];
                                String companyYear = splitText[1];
                                // TODO: 내용 불러오기
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Column(
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
                                    Row(
                                      children: [
                                        _buildDChart(companyName, "PRISM 스코어"),
                                        _buildDChart(companyName, "E"),
                                        _buildDChart(companyName, "S"),
                                        _buildDChart(companyName, "G"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        _buildDChart(companyName, "wPRISM 스코어"),
                                        _buildDChart(companyName, "E"),
                                        _buildDChart(companyName, "S"),
                                        _buildDChart(companyName, "G"),
                                      ],
                                    ),
                                    _buildAssociationRakingTable("KCGS"),
                                    _buildAssociationRakingTable("한국ESG연구소"),
                                    if (comparing_gris.isEmpty)
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: const Text(
                                              "GRI index를 선택해주세요 (최대 5개)"))
                                    else
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Text("$comparing_gris"))
                                  ],
                                );
                              }),
                            ),
                          ),
                      ],
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

  SizedBox _buildAssociationRakingTable(String association) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: 300,
      child: Table(
        children: const [
          TableRow(
            children: [
              TableCell(child: Text("종합점수")),
              TableCell(child: Text("A")), // TODO: 점수 받아오기
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Text("E")),
              TableCell(child: Text("A")), // TODO: 점수 받아오기
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Text("S")),
              TableCell(child: Text("A")), // TODO: 점수 받아오기
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Text("G")),
              TableCell(child: Text("A")), // TODO: 점수 받아오기
            ],
          ),
        ],
      ),
    );
  }

  Column _buildDChart(String companyName, String title) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: MediaQuery.of(context).size.height / 4 - 100,
          child: SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                dataSource: <ChartData>[
                  ChartData(companyName, 40),
                  ChartData("업종", 65),
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
        const Text("40",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        const Text("업계 평균 65",
            style: TextStyle(fontSize: 10, color: Color(0xff667085))),
        const Text("업계 152위",
            style: TextStyle(fontSize: 10, color: Color(0xff667085))),
        const Text("전체 152위",
            style: TextStyle(fontSize: 10, color: Color(0xff667085))),
      ],
    );
  }

  Container rankingTab(BuildContext context, String scoreName) {
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
                        search_name = value;
                      },
                    ),
                  ),
                  // 업종 필터링
                  SizedBox(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        chooseIndustries(context);
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
                  if (rowIndex >= company_list.length) {
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
                              showDialog<String>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) => AlertDialog(
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (comparing_items.contains(
                                              '${company_list[rowIndex].name}\n2020')) {
                                            comparing_items.remove(
                                                '${company_list[rowIndex].name}\n2020');
                                          } else {
                                            if (comparing_items.length < 3) {
                                              comparing_items.add(
                                                  '${company_list[rowIndex].name}\n2020');
                                            }
                                          }
                                          Navigator.pop(
                                            context,
                                          );
                                          setState(() {});
                                        },
                                        child: Text(
                                          "2020",
                                          style: TextStyle(
                                            fontWeight: comparing_items.contains(
                                                    '${company_list[rowIndex].name}\n2020')
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (comparing_items.contains(
                                              '${company_list[rowIndex].name}\n2021')) {
                                            // 수정: 기업명\n연도 로 수정할 것
                                            comparing_items.remove(
                                                '${company_list[rowIndex].name}\n2021'); // 수정: 기업명\n연도 로 수정할 것
                                          } else {
                                            if (comparing_items.length < 3) {
                                              comparing_items.add(
                                                  '${company_list[rowIndex].name}\n2021'); // 수정: 기업명\n연도 로 수정할 것
                                            }
                                          }
                                          Navigator.pop(
                                            context,
                                          );
                                          setState(() {});
                                        },
                                        child: Text(
                                          "2021",
                                          style: TextStyle(
                                            fontWeight: comparing_items.contains(
                                                    '${company_list[rowIndex].name}\n2021')
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (comparing_items.contains(
                                              '${company_list[rowIndex].name}\n2022')) {
                                            // 수정: 기업명\n연도 로 수정할 것
                                            comparing_items.remove(
                                                '${company_list[rowIndex].name}\n2022'); // 수정: 기업명\n연도 로 수정할 것
                                          } else {
                                            if (comparing_items.length < 3) {
                                              comparing_items.add(
                                                  '${company_list[rowIndex].name}\n2022'); // 수정: 기업명\n연도 로 수정할 것
                                            }
                                          }
                                          Navigator.pop(
                                            context,
                                          );
                                          setState(() {});
                                        },
                                        child: Text(
                                          "2022",
                                          style: TextStyle(
                                            fontWeight: comparing_items.contains(
                                                    '${company_list[rowIndex].name}\n2022')
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        DataCell(Text((rowIndex + 1).toString())),
                        DataCell(Text(company_list[rowIndex].name)), // 수정
                        DataCell(Text(company_list[rowIndex].industry)), // 수정
                        const DataCell(Text("100")),
                        const DataCell(
                          Row(
                            children: [
                              Text(" KCGS "),
                              Text(" 한국ESG연구소 "),
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecondPage(company_list[rowIndex])));
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
              numberPages: (company_list.length / 10).ceil(),
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

  Future<String?> chooseIndustries(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부: 닫음
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
            onPressed: () => Navigator.pop(context, 'OK'),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'GRI index 검색..',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Column(
              children: List.generate(
                (gris.length / 5).ceil(),
                (rowIndex) => Row(
                  children: List.generate(
                    5,
                    (index) {
                      final currentIndex = rowIndex * 5 + index;
                      if (currentIndex < gris.length) {
                        return Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (comparing_gris
                                    .contains(gris[currentIndex])) {
                                  comparing_gris.remove(gris[currentIndex]);
                                } else {
                                  comparing_gris.add(gris[currentIndex]);
                                }
                              });
                            },
                            child: Text(
                              gris[currentIndex],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight:
                                    comparing_gris.contains(gris[currentIndex])
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(child: Container());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
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
