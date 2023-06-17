// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import 'package:flutter/material.dart';
// import 'package:number_paginator/number_paginator.dart';

// import '../models/company_model.dart';
// import '../models/esglab_score_model.dart';
// import '../models/kcgs_score_model.dart';
// import '../models/prism_score_model.dart';
// import '../models/sustain_report_model.dart';
// import '../services/api_services.dart';
// import 'detail_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     super.key,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late List<CompanyModel> companyList = [];

//   PageController page = PageController();
//   SideMenuController sideMenu = SideMenuController();

//   late TabController tabController;
//   late TabController _associationTabController;

//   final int _currentPage = 0;

//   int suggestionsCount = 12;

//   Set<int> selectedItems = {};

//   List<String> comparingItems = [];

//   List<String> comparingIndustries = [];
//   List<String> comparingGRI = [];

//   String searchName = "";

//   List<String> industries = [
//     '에너지장비및서비스',
//     '석유와가스',
//     '화학',
//     '포장재',
//     '비철금속',
//     '철강',
//     '종이와목재',
//     '우주항공과국방',
//     '건축제품',
//     '건축자재',
//     '건설',
//     '가구',
//     '전기장비',
//     '복합기업',
//     '기계',
//     '조선',
//     '무역회사와판매업체',
//     '상업서비스와공급품',
//     '항공화물운송과물류',
//     '항공사',
//     '해운사',
//     '도로와철도운송',
//     '운송인프라',
//     '자동차와부품',
//     '가정용기기와용품',
//     '레저용장비와제품',
//     '섬유,의류,신발,호화품,문구류',
//     '화장품',
//     '호텔,레스토랑,레저등',
//     '소매유통',
//     '교육서비스',
//     '식품과기본식료품소매',
//     '식품,음료,담배',
//     '가정용품과개인용품',
//     '건강관리장비와서비스',
//     '생물공학',
//     '제약',
//     '생명과학도구및서비스',
//     '금융',
//     '소프트웨어와서비스',
//     '기술하드웨어와장비',
//     '반도체와반도체장비',
//     '전자와전기제품',
//     '디스플레이',
//     '전기통신서비스',
//     '광고',
//     '방송과엔터테인먼트',
//     '출판',
//     '게임엔터테인먼트',
//     '양방향미디어와서비스',
//     '전기,가스 유틸리티',
//   ];
//   List<String> gris = [
//     "201-1",
//     "202-2",
//   ];

//   @override
//   void initState() {
//     ApiService.outCompany(comparingIndustries, searchName).then((outCompany) {
//       setState(() {
//         companyList = outCompany;
//       });
//     }).catchError((error) {
//       print('Error fetching companies: $error');
//     });

//     sideMenu.addListener((p0) {
//       page.jumpToPage(p0);
//     });
//     tabController = TabController(length: 8, vsync: this);
//     _associationTabController = TabController(length: 2, vsync: this);
//     // selected = List<bool>.generate(
//     //     numItems, (int index) => selectedItems.contains(index));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     _associationTabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SideMenu(
//             controller: sideMenu,
//             style: SideMenuStyle(
//               displayMode: SideMenuDisplayMode.auto,
//               selectedColor: const Color(0xffD7EDFF),
//               selectedTitleTextStyle: const TextStyle(color: Color(0xff0E73F6)),
//               selectedIconColor: const Color(0xff4A41FF),
//               unselectedTitleTextStyle:
//                   const TextStyle(color: Color(0xff0E73F6)),
//               unselectedIconColor: const Color(0xff972ACA),
//               backgroundColor: const Color(0xffF6F8F9),
//               iconSize: 40,
//               openSideMenuWidth: 200,
//               compactSideMenuWidth: 80,
//               itemHeight: 65,
//             ),
//             title: const Column(
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         SizedBox(width: 20),
//                         Image(
//                           image:
//                               AssetImage('../../assets/images/PRISM-logo.png'),
//                           width: 40,
//                           height: 40,
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           "PRISM",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ],
//             ),
//             items: [
//               SideMenuItem(
//                 priority: 0,
//                 title: 'Ranking',
//                 onTap: (page, _) {
//                   sideMenu.changePage(page);
//                 },
//                 icon: const Icon(Icons.home),
//               ),
//               SideMenuItem(
//                 priority: 1,
//                 title: 'Comparing',
//                 onTap: (page, _) {
//                   comparingItems.length > 1
//                       ? sideMenu.changePage(page)
//                       : sideMenu.currentPage;
//                 },
//                 icon: const Icon(Icons.file_copy_rounded),
//               ),
//               SideMenuItem(
//                 priority: 2,
//                 title: comparingItems.isNotEmpty ? comparingItems[0] : "",
//                 onTap: (page, _) {
//                   comparingItems.remove(comparingItems[0]);
//                   setState(() {});
//                 },
//               ),
//               SideMenuItem(
//                 priority: 2,
//                 title: comparingItems.length > 1 ? comparingItems[1] : "",
//                 onTap: (page, _) {
//                   comparingItems.remove(comparingItems[1]);
//                   setState(() {});
//                 },
//               ),
//               SideMenuItem(
//                 priority: 2,
//                 title: comparingItems.length == 3 ? comparingItems[2] : "",
//                 onTap: (page, _) {
//                   comparingItems.remove(comparingItems[2]);
//                   setState(() {});
//                 },
//               ),
//             ],
//           ),
//           Expanded(
//             child: PageView(
//               controller: page,
//               children: [
//                 // 랭킹
//                 Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title
//                         const Text(
//                           'ESG 랭킹',
//                           style: TextStyle(
//                             fontSize: 35,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         // prism 랭킹 탭
//                         TabBar(
//                           controller: tabController,
//                           tabs: const [
//                             Tab(text: 'prism-ALL'),
//                             Tab(text: 'prism-E'),
//                             Tab(text: 'prism-S'),
//                             Tab(text: 'prism-G'),
//                             Tab(text: 'Wprism-ALL'),
//                             Tab(text: 'Wprism-E'),
//                             Tab(text: 'Wprism-S'),
//                             Tab(text: 'Wprism-G'),
//                           ],
//                           indicatorColor: Colors.black,
//                           labelColor: Colors.black,
//                           labelStyle:
//                               const TextStyle(fontWeight: FontWeight.bold),
//                           unselectedLabelStyle:
//                               const TextStyle(fontWeight: FontWeight.normal),
//                         ),
//                         // 각 탭 - rankingTab
//                         Expanded(
//                           child: TabBarView(
//                             controller: tabController,
//                             children: [
//                               rankingTab(context, "prism-ALL"),
//                               rankingTab(context, "prism-E"),
//                               rankingTab(context, "prism-S"),
//                               rankingTab(context, "prism-G"),
//                               rankingTab(context, "Wprism-ALL"),
//                               rankingTab(context, "Wprism-E"),
//                               rankingTab(context, "Wprism-S"),
//                               rankingTab(context, "Wprism-G"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // 비교
//                 Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "ESG 비교",
//                           style: TextStyle(
//                             fontSize: 35,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         OutlinedButton.icon(
//                           onPressed: () {
//                             chooseGRI(context);
//                           },
//                           icon: const Icon(Icons.filter_list,
//                               size: 18, color: Color(0xff5B6871)),
//                           label: const Text("GRI index",
//                               style: TextStyle(color: Color(0xff252C32))),
//                         ),
//                         if (comparingGRI.isNotEmpty)
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children:
//                                   List.generate(comparingGRI.length, (index) {
//                                 var gri = comparingGRI[index];
//                                 return Row(
//                                   children: [
//                                     const SizedBox(width: 10),
//                                     OutlinedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           comparingGRI.remove(gri);
//                                         });
//                                       },
//                                       style: TextButton.styleFrom(
//                                         foregroundColor: Colors.white,
//                                         backgroundColor:
//                                             const Color(0xff4A41FF),
//                                       ),
//                                       child: Text(
//                                         gri,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }),
//                             ),
//                           ),
//                         if (comparingItems.isNotEmpty)
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Column(
//                               children:
//                                   List.generate(comparingItems.length, (index) {
//                                 var item = comparingItems[index];
//                                 List<String> splitText = item.split("\n");
//                                 String companyName = splitText[0];
//                                 String companyYear = splitText[1];

//                                 return Row(
//                                   children: [
//                                     Text(item),
//                                     printPrismInfo(
//                                         companyName, companyYear, "PRISM 스코어"),
//                                     printPrismInfo(
//                                         companyName, companyYear, "wPRISM 스코어"),
//                                     TabBar(
//                                       controller: _associationTabController,
//                                       tabs: const [
//                                         Tab(text: 'KCGS'),
//                                         Tab(text: '한국ESG연구소'),
//                                       ],
//                                       indicatorColor: Colors.black,
//                                       labelColor: Colors.black,
//                                       labelStyle: const TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                       unselectedLabelStyle: const TextStyle(
//                                           fontWeight: FontWeight.normal),
//                                     ),
//                                     Expanded(
//                                       child: TabBarView(
//                                         controller: _associationTabController,
//                                         children: [
//                                           associationInfo(companyName, 'KCGS'),
//                                           associationInfo(
//                                               companyName, '한국ESG연구소'),
//                                         ],
//                                       ),
//                                     ),
//                                     // TODO: GRI 정보 출력 - 함수 만들기 : 인자로 리스트 (comparingGRI) 주기
//                                     if (comparingGRI.isEmpty)
//                                       const Text("all")
//                                     else
//                                       Text("$comparingGRI"),
//                                   ],
//                                 );
//                               }),
//                             ),
//                           )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   DataTable associationInfo(String companyName, String association) {
//     int? id;

//     ApiService.outCompanyId(companyName).then((outCompanyId) {
//       id = outCompanyId;
//     });

//     String overallScore = "...", eScore = "...", sScore = "...", gScore = "...";

//     if (association == 'KCGS') {
//       ApiService.outKcgsScore(id).then((outKcgsScore) {
//         overallScore = outKcgsScore!.overallScore;
//         eScore = outKcgsScore.EScore;
//         sScore = outKcgsScore.SScore;
//         gScore = outKcgsScore.GScore;
//       }).catchError((error) {
//         print('Error fetching companies: $error');
//       });
//     } else if (association == '한국ESG연구소') {
//       ApiService.outEsglabScore(id).then((outEsglabScore) {
//         overallScore = outEsglabScore!.overallScore;
//         eScore = outEsglabScore.EScore;
//         sScore = outEsglabScore.SScore;
//         gScore = outEsglabScore.GScore;
//       }).catchError((error) {
//         print('Error fetching companies: $error');
//       });
//     }

//     return DataTable(
//       columns: const <DataColumn>[
//         DataColumn(
//           label: Expanded(
//             child: Text(''),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(''),
//           ),
//         ),
//       ],
//       rows: [
//         DataRow(
//           cells: [
//             const DataCell(Text('종합점수')),
//             DataCell(Text(overallScore)),
//           ],
//         ),
//         DataRow(
//           cells: [
//             const DataCell(Text('E')),
//             DataCell(Text(eScore)),
//           ],
//         ),
//         DataRow(
//           cells: [
//             const DataCell(Text('S')),
//             DataCell(Text(sScore)),
//           ],
//         ),
//         DataRow(
//           cells: [
//             const DataCell(Text('G')),
//             DataCell(Text(gScore)),
//           ],
//         ),
//       ],
//     );
//   }

//   Column printPrismInfo(String name, String year, String score) {
//     // TODO: name, year, score 이용해서 chart 출력하기
//     return Column(
//       children: [
//         Text(score),
//         // TODO: pie chart
//         // TODO: ESG pie chart
//       ],
//     );
//   }

//   Container rankingTab(BuildContext context, String scoreName) {
//     // 랭킹 Row 생성
//     List<DataRow> rows = List<DataRow>.generate(
//       companyList.length,
//       (index) {
//         final company = companyList[index];
//         return DataRow(
//           cells: [
//             addComparing(context, company),
//             DataCell(Text((index + 1).toString())),
//             extractCompanyInfo(company, "Name"),
//             extractCompanyInfo(company, "Industry"),
//             extractCompanyInfo(company, scoreName),
//             usingAssociation(company),
//             moveDetailInfo(context, company.name),
//           ],
//         );
//       },
//     );

//     return Container(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 16,
//             ),
//             SizedBox(
//               height: 80,
//               child: GridView.count(
//                 // 필러팅 섹션
//                 // TODO: 가능하면 view 너비 다르게 설정할 수 있는 위젯 찾아보기
//                 crossAxisCount: 3,
//                 childAspectRatio:
//                     (MediaQuery.of(context).size.width - 200) / 100,
//                 children: [
//                   // 기업명 검색
//                   // TODO: 기업명 검색 처리할 로직 구현 확인
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         hintText: '기업명 검색..',
//                         prefixIcon: Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         searchName = value;
//                         ApiService.outCompany(comparingIndustries, searchName)
//                             .then((outCompany) {
//                           setState(() {
//                             companyList = outCompany;
//                           });
//                         }).catchError((error) {
//                           print('Error fetching companies: $error');
//                         });
//                       },
//                     ),
//                   ),
//                   // 업종 필터링
//                   SizedBox(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         chooseIndustries(context);
//                         ApiService.outCompany(comparingIndustries, searchName)
//                             .then((outCompany) {
//                           setState(() {
//                             companyList = outCompany;
//                           });
//                         }).catchError((error) {
//                           print('Error fetching companies: $error');
//                         });
//                       },
//                       icon: const Icon(
//                         Icons.filter_list,
//                         size: 18,
//                         color: Color(0xff5B6871),
//                       ),
//                       label: const Text(
//                         "업종 필터링",
//                         style: TextStyle(
//                           color: Color(0xff252C32),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // 선택된 업종 표시
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children:
//                           List.generate(comparingIndustries.length, (index) {
//                         var industry = comparingIndustries[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: OutlinedButton(
//                             onPressed: () {
//                               setState(() {
//                                 comparingIndustries.remove(industry);
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: const Color(0xff4A41FF),
//                             ),
//                             child: Text(
//                               industry,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 DataTable(
//                   columns: <DataColumn>[
//                     dataColumnHeader("비교"),
//                     dataColumnHeader("순위"),
//                     dataColumnHeader("기업명"),
//                     dataColumnHeader("업종"),
//                     dataColumnHeader("PRISM 스코어"),
//                     dataColumnHeader("ESG 평가기관"),
//                     dataColumnHeader("세부정보"),
//                   ],
//                   rows: rows,
//                 ),
//                 NumberPaginator(
//                   // by default, the paginator shows numbers as center content
//                   numberPages: companyList.length ~/ 10 + 1,
//                   onPageChange: (int index) {
//                     setState(() {
//                       _currentPage;
//                       index; // _currentPage is a variable within State of StatefulWidget
//                     });
//                   },
//                   // initially selected index
//                   initialPage: 0,
//                   config: const NumberPaginatorUIConfig(
//                     // default height is 48
//                     height: 48,
//                     // buttonShape: BeveledRectangleBorder(
//                     //   borderRadius:
//                     //       BorderRadius.circular(8),
//                     // ),
//                     buttonSelectedForegroundColor: Colors.black,
//                     buttonUnselectedForegroundColor: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // TODO: 보내야할 인지가 있지 않을까? detail_screen.dart 수정하기 전에 체크할 것
//   DataCell moveDetailInfo(BuildContext context, String companyName) {
//     return DataCell(
//       IconButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => SecondPage(companyName)));
//         },
//         icon: const Icon(
//           Icons.arrow_right,
//         ),
//       ),
//     );
//   }

//   // DataCell usingAssociation(final companyName) {
//   //   KcgsScoreModel? kcgsScore;
//   //   ApiService.outKcgsScore(CompanyModel.fromJson(companyName).id)
//   //       .then((outKcgsScore) {
//   //     kcgsScore = outKcgsScore;
//   //   }).catchError((error) {
//   //     print('Error fetching companies: $error');
//   //   });

//   //   EsglabScoreModel? esglabScore;
//   //   ApiService.outEsglabScore(CompanyModel.fromJson(companyName).id)
//   //       .then((outEsglabScore) {
//   //     esglabScore = outEsglabScore;
//   //   }).catchError((error) {
//   //     print('Error fetching companies: $error');
//   //   });

//   //   return DataCell(
//   //     Row(
//   //       children: [
//   //         kcgsScore != null
//   //             ? Container(
//   //                 decoration: BoxDecoration(
//   //                   borderRadius: BorderRadius.circular(50),
//   //                   border: Border.all(
//   //                     color: Colors.black,
//   //                   ),
//   //                 ),
//   //                 child: const Text(
//   //                   " KCGS ",
//   //                 ),
//   //               )
//   //             : Container(),
//   //         esglabScore != null
//   //             ? Container(
//   //                 decoration: BoxDecoration(
//   //                   borderRadius: BorderRadius.circular(50),
//   //                   border: Border.all(
//   //                     color: Colors.black,
//   //                   ),
//   //                 ),
//   //                 child: const Text(
//   //                   " 한국ESG연구소 ",
//   //                 ),
//   //               )
//   //             : Container(),
//   //       ],
//   //     ),
//   //   );
//   // }

//   DataCell usingAssociation(final CompanyModel company) {
//     return DataCell(
//       Row(
//         children: [
//           FutureBuilder<KcgsScoreModel?>(
//             future: ApiService.outKcgsScore(company.id),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(
//                       color: Colors.black,
//                     ),
//                   ),
//                   child: const Text(
//                     " KCGS ",
//                   ),
//                 );
//               }
//               return Container();
//             },
//           ),
//           FutureBuilder<EsglabScoreModel?>(
//             future: ApiService.outEsglabScore(company.id),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(
//                       color: Colors.black,
//                     ),
//                   ),
//                   child: const Text(
//                     " 한국ESG연구소 ",
//                   ),
//                 );
//               }
//               return Container();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // DataCell extractCompanyInfo(final companyName, String info) {
//   //   return DataCell(
//   //     FutureBuilder<CompanyModel>(
//   //       future: companyName,
//   //       builder: (context, snapshot) {
//   //         if (snapshot.hasData) {
//   //           if (info == "Name") {
//   //             return Text(
//   //               snapshot.data!.name,
//   //             );
//   //           } else if (info == "Industry") {
//   //             return Text(
//   //               snapshot.data!.industry,
//   //             );
//   //           } else {
//   //             ApiService.outPrismScore(snapshot.data!.id).then((outPrismScore) {
//   //               if (info == "prism-ALL") {
//   //                 return Text(outPrismScore.overallScore.toString());
//   //               } else if (info == "prism-E") {
//   //                 return Text(outPrismScore.EScore.toString());
//   //               } else if (info == "prism-S") {
//   //                 return Text(outPrismScore.SScore.toString());
//   //               } else if (info == "prism-G") {
//   //                 return Text(outPrismScore.GScore.toString());
//   //               } else if (info == "Wprism-All") {
//   //                 return Text(outPrismScore.WOverallScore.toString());
//   //               } else if (info == "Wprism-E") {
//   //                 return Text(outPrismScore.WEScore.toString());
//   //               } else if (info == "Wprism-S") {
//   //                 return Text(outPrismScore.WSScore.toString());
//   //               } else if (info == "Wprism-G") {
//   //                 return Text(outPrismScore.WGScore.toString());
//   //               }
//   //             }).catchError((error) {
//   //               print('Error fetching companies: $error');
//   //             });
//   //           }
//   //         }
//   //         return const Text("...");
//   //       },
//   //     ),
//   //   );
//   // }
//   DataCell extractCompanyInfo(final CompanyModel company, String info) {
//     return DataCell(
//       FutureBuilder<CompanyModel>(
//         future: Future.value(company),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (info == "Name") {
//               return Text(
//                 snapshot.data!.name,
//               );
//             } else if (info == "Industry") {
//               return Text(
//                 snapshot.data!.industry,
//               );
//             } else {
//               return FutureBuilder<PrismScoreModel?>(
//                 future: ApiService.outPrismScore(snapshot.data!.id),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     final prismScore = snapshot.data!;
//                     if (info == "prism-ALL") {
//                       return Text(prismScore.overallScore.toString());
//                     } else if (info == "prism-E") {
//                       return Text(prismScore.EScore.toString());
//                     } else if (info == "prism-S") {
//                       return Text(prismScore.SScore.toString());
//                     } else if (info == "prism-G") {
//                       return Text(prismScore.GScore.toString());
//                     } else if (info == "Wprism-All") {
//                       return Text(prismScore.WOverallScore.toString());
//                     } else if (info == "Wprism-E") {
//                       return Text(prismScore.WEScore.toString());
//                     } else if (info == "Wprism-S") {
//                       return Text(prismScore.WSScore.toString());
//                     } else if (info == "Wprism-G") {
//                       return Text(prismScore.WGScore.toString());
//                     }
//                   }
//                   return const Text("...");
//                 },
//               );
//             }
//           }
//           return const Text("...");
//         },
//       ),
//     );
//   }

//   DataCell addComparing(BuildContext context, final company) {
//     List<SustainReport> companyReports = [];

//     ApiService.outSustainReport(CompanyModel.fromJson(company).id)
//         .then((outSustainReport) {
//       companyReports = outSustainReport;
//     }).catchError((error) {
//       print('Error fetching companies: $error');
//     });

//     return DataCell(
//       IconButton(
//         onPressed: () {
//           showDialog<String>(
//             context: context,
//             barrierDismissible: true,
//             builder: (BuildContext context) => AlertDialog(
//               content: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: List<TextButton>.generate(
//                   companyReports.length,
//                   (index) {
//                     final companyReport = companyReports[index];
//                     return TextButton(
//                       onPressed: () {
//                         if (comparingItems.contains(
//                             '${CompanyModel.fromJson(company).name}\n${companyReport.year.toString()}')) {
//                           comparingItems.remove(
//                               '${CompanyModel.fromJson(company).name}\n${companyReport.year.toString()}');
//                         } else {
//                           comparingItems.add(
//                               '${CompanyModel.fromJson(company).name}\n${companyReport.year.toString()}');
//                         }
//                         Navigator.pop(
//                           context,
//                         );
//                         setState(() {});
//                       },
//                       child: Text(companyReport.year.toString()),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//         icon: const Icon(Icons.add),
//       ),
//     );
//   }

//   DataColumn dataColumnHeader(String header) {
//     return DataColumn(
//       label: Expanded(
//         child: Text(
//           header,
//           style: const TextStyle(
//             color: Color(0xff84919A),
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   Future<String?> chooseIndustries(BuildContext context) {
//     return showDialog<String>(
//       context: context,
//       barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부: 닫음
//       builder: (BuildContext context) => AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(
//             (industries.length / 5).ceil(),
//             (rowIndex) => Row(
//               children: List.generate(
//                 5,
//                 (index) => (rowIndex * 5 + index < industries.length)
//                     ? Expanded(
//                         child: TextButton(
//                           onPressed: () {
//                             setState(() {
//                               if (comparingIndustries
//                                   .contains(industries[rowIndex * 5 + index])) {
//                                 comparingIndustries
//                                     .remove(industries[rowIndex * 5 + index]);
//                               } else {
//                                 comparingIndustries
//                                     .add(industries[rowIndex * 5 + index]);
//                               }
//                             });
//                           },
//                           child: Text(
//                             industries[rowIndex * 5 + index],
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: comparingIndustries.contains(
//                                       industries[rowIndex * 5 + index])
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//               ),
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'OK'),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // TODO: 출력 화면 디테일 수정
//   // TODO: 검색창 추가
//   Future<String?> chooseGRI(BuildContext context) {
//     return showDialog<String>(
//       context: context,
//       barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
//       builder: (BuildContext context) => AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(
//             (industries.length / 5).ceil(),
//             (rowIndex) => Row(
//               children: List.generate(
//                 5,
//                 (index) => (rowIndex * 5 + index < gris.length)
//                     ? Expanded(
//                         child: TextButton(
//                           onPressed: () {
//                             setState(() {
//                               if (comparingGRI
//                                   .contains(gris[rowIndex * 5 + index])) {
//                                 comparingGRI.remove(gris[rowIndex * 5 + index]);
//                               } else {
//                                 comparingGRI.add(gris[rowIndex * 5 + index]);
//                               }
//                             });
//                           },
//                           child: Text(
//                             gris[rowIndex * 5 + index],
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: comparingGRI
//                                       .contains(gris[rowIndex * 5 + index])
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       )
//                     : Expanded(child: Container()),
//               ),
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'OK'),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
