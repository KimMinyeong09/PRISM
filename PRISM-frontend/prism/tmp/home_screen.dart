import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();

  late TabController tabController;

  int _currentPage = 0;

  int suggestionsCount = 12;
  // final focus = FocusNode();

  Set<int> selectedItems = {};

  static const int numItems = 10;
  List<bool> selected = [];

  List<String> comparingItems = [];

  List<String> comparingCategories = [];
  List<String> comparingGRI = [];

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
  List<String> gris = [
    "201-1",
    "202-2",
  ];

  @override
  void initState() {
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    tabController = TabController(length: 8, vsync: this);
    selected = List<bool>.generate(
        numItems, (int index) => selectedItems.contains(index));
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
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
                  sideMenu.changePage(page);
                },
                // icon: Image.asset('../../assets/images/Ranking-icon.png'),
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Comparing',
                onTap: (page, _) {
                  comparingItems.length > 1
                      ? sideMenu.changePage(page)
                      : sideMenu.currentPage;
                },
                icon: const Icon(Icons.file_copy_rounded),
                // trailing: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       // decoration: BoxDecoration(
                //       //   color: Colors.amber,
                //       //   borderRadius: BorderRadius.all(Radius.circular(6)),
                //       // ),
                //       padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                //       child: Text(comparingItems.length >= 1 ?
                //         '${comparingItems[0]}\n2020' : '',
                //         style: TextStyle(fontSize: 11, color: Colors.black),
                //       ),
                //     ),
                //     //SizedBox(height: 8),
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                //       child: Text(comparingItems.length >= 2 ?
                //         '${comparingItems[1]}\n2020' : '',
                //         style: TextStyle(fontSize: 11, color: Colors.black),
                //       ),
                //     ),
                //     //SizedBox(height: 8),
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                //       child: Text(comparingItems.length == 3 ?
                //         '${comparingItems[2]}\n2020' : '',
                //         style: TextStyle(fontSize: 11, color: Colors.black),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              SideMenuItem(
                priority: 2,
                title: comparingItems.isNotEmpty ? comparingItems[0] : "",
                onTap: (page, _) {
                  comparingItems.remove('삼성전자\n2020'); // 수정
                  setState(() {});
                },
              ),
              SideMenuItem(
                priority: 2,
                title: comparingItems.length > 1 ? comparingItems[1] : "",
                onTap: (page, _) {
                  comparingItems.remove('삼성전자\n2020'); // 수정
                  setState(() {});
                },
              ),
              SideMenuItem(
                priority: 2,
                title: comparingItems.length == 3 ? comparingItems[2] : "",
                onTap: (page, _) {
                  comparingItems.remove('삼성전자\n2020'); // 수정
                  setState(() {});
                },
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESG 랭킹',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TabBar(
                          controller: tabController,
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
                            controller: tabController,
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25, // 화면의 1/4 크기로 설정
                                            height: 75,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                hintText: '기업명 검색..',
                                                prefixIcon: Icon(Icons.search),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                              ),
                                              onChanged: (value) {
                                                // 검색어 변경 시 처리할 로직 추가
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                chooseIndustries(context);
                                              },
                                              icon: const Icon(
                                                  Icons.filter_list,
                                                  size: 18,
                                                  color: Color(0xff5B6871)),
                                              label: const Text("업종 필터링",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff252C32))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (comparingCategories.isNotEmpty)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                comparingCategories.length,
                                                (index) {
                                              var category =
                                                  comparingCategories[index];
                                              return Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        comparingCategories
                                                            .remove(category);
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff4A41FF),
                                                    ),
                                                    child: Text(
                                                      category,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
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
                                        rows: [
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        content: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            // 수정: DB에서 연도 들고 와야함
                                                            TextButton(
                                                              onPressed: () {
                                                                if (comparingItems
                                                                    .contains(
                                                                        '삼성전자\n2020')) {
                                                                  // 수정: 기업명\n연도 로 수정할 것
                                                                  comparingItems
                                                                      .remove(
                                                                          '삼성전자\n2020'); // 수정: 기업명\n연도 로 수정할 것
                                                                } else {
                                                                  comparingItems
                                                                      .add(
                                                                          '삼성전자\n2020'); // 수정: 기업명\n연도 로 수정할 것
                                                                }
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                "2020",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight: comparingItems
                                                                          .contains(
                                                                              '삼성전자\n2020')
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                if (comparingItems
                                                                    .contains(
                                                                        '삼성전자\n2021')) {
                                                                  // 수정: 기업명\n연도 로 수정할 것
                                                                  comparingItems
                                                                      .remove(
                                                                          '삼성전자\n2021'); // 수정: 기업명\n연도 로 수정할 것
                                                                } else {
                                                                  comparingItems
                                                                      .add(
                                                                          '삼성전자\n2021'); // 수정: 기업명\n연도 로 수정할 것
                                                                }
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                "2021",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight: comparingItems
                                                                          .contains(
                                                                              '삼성전자\n2021')
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ),
                                                            // TextButton(
                                                            //   onPressed: () {
                                                            //     Navigator.pop(
                                                            //       context,
                                                            //     );
                                                            //     setState(() {});
                                                            //   },
                                                            //   child: const Text(
                                                            //       "2021"),
                                                            // ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                setState(() {});
                                                              },
                                                              child: const Text(
                                                                  "2022"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ),
                                              const DataCell(Text(
                                                  '1')), // 수정: DB에서 순위로 들고 올 것 혹은 for 문 쓰면 index로 할 것
                                              const DataCell(Text(
                                                  '삼성전자')), // 수정: DB에서 기업명 들고 올 것
                                              const DataCell(Text(
                                                  '분류')), // 수정: DB에서 업종 들고 올 것
                                              const DataCell(Text(
                                                  '100')), // 수정: DB에서 점수 들고 올 것
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      " KCGS ",
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      " 한국ESG연구소 ",
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SecondPage()));
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_right,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: [
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ),
                                              const DataCell(Text('2')),
                                              const DataCell(Text('삼성전자')),
                                              const DataCell(Text('분류')),
                                              const DataCell(Text('100')),
                                              const DataCell(Text('하나 둘')),
                                              const DataCell(Text('더보기')),
                                            ],
                                          ),
                                          // 추가적인 DataRow들...
                                        ],
                                      ),
                                      NumberPaginator(
                                        // by default, the paginator shows numbers as center content
                                        numberPages:
                                            10, // 수정: 데이터 개수 보고 결정 (총 개수 / 10 -> 올림)
                                        onPageChange: (int index) {
                                          setState(() {
                                            _currentPage = 0;
                                            index; // _currentPage is a variable within State of StatefulWidget
                                          });
                                        },
                                        // initially selected index
                                        initialPage: 0,
                                        config: const NumberPaginatorUIConfig(
                                          // default height is 48
                                          height: 48,
                                          // buttonShape: BeveledRectangleBorder(
                                          //   borderRadius:
                                          //       BorderRadius.circular(8),
                                          // ),
                                          buttonSelectedForegroundColor:
                                              Colors.black,
                                          buttonUnselectedForegroundColor:
                                              Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: const Column(
                                  children: [
                                    Text(
                                      'prism_E 랭킹',
                                      style: TextStyle(fontSize: 35),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                        OutlinedButton.icon(
                          onPressed: () {
                            chooseGRI(context);
                          },
                          icon: const Icon(Icons.filter_list,
                              size: 18, color: Color(0xff5B6871)),
                          label: const Text("GRI index",
                              style: TextStyle(color: Color(0xff252C32))),
                        ),
                        if (comparingGRI.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  List.generate(comparingGRI.length, (index) {
                                var gri = comparingGRI[index];
                                return Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          comparingGRI.remove(gri);
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
                                  ],
                                );
                              }),
                            ),
                          ),
                        comparingItems.isNotEmpty
                            ? Row(
                                // 리스트로 여러 개 형성 & 가로 스크롤
                                children: [
                                  Text(
                                    comparingItems[0],
                                  ),
                                  const Column(
                                    children: [
                                      Text(
                                        "PRISM 스코어",
                                      ),
                                      // pie chart
                                      // ESG pie chart
                                    ],
                                  ),
                                  const Column(
                                    children: [
                                      Text(
                                        "wPRISM 스코어",
                                      ),
                                      // pie chart
                                      // ESG pie chart
                                    ],
                                  ),
                                  // 탭바

                                  if (comparingGRI.isEmpty)
                                    // 전체 다 출력
                                    const Text("all")
                                  else
                                    // list 이용해서 comparingGRI에 있는 것만 출력
                                    Text("$comparingGRI")
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> chooseIndustries(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
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
                              if (comparingCategories
                                  .contains(industries[rowIndex * 5 + index])) {
                                comparingCategories
                                    .remove(industries[rowIndex * 5 + index]);
                              } else {
                                comparingCategories
                                    .add(industries[rowIndex * 5 + index]);
                              }
                            });
                          },
                          child: Text(
                            industries[rowIndex * 5 + index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: comparingCategories.contains(
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
          children: List.generate(
            (industries.length / 5).ceil(),
            (rowIndex) => Row(
              children: List.generate(
                5,
                (index) => (rowIndex * 5 + index < gris.length)
                    ? Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (comparingGRI
                                  .contains(gris[rowIndex * 5 + index])) {
                                comparingGRI.remove(gris[rowIndex * 5 + index]);
                              } else {
                                comparingGRI.add(gris[rowIndex * 5 + index]);
                              }
                            });
                          },
                          child: Text(
                            gris[rowIndex * 5 + index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: comparingGRI
                                      .contains(gris[rowIndex * 5 + index])
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
}
