import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:prism/models/gri_info_model.dart';
import 'package:prism/models/prism_ind_avg_score_model.dart';
import 'package:prism/models/prism_score_model.dart';
import 'package:prism/models/report_table_model.dart';
import 'package:prism/models/sustain_report_model.dart';

import '../models/esglab_ind_avg_score_model.dart';
import '../models/esglab_score_model.dart';
import '../models/gri_usage_ind_avg_score_model.dart';
import '../models/kcgs_ind_avg_score_model.dart';
import '../models/kcgs_score_model.dart';
import '../models/one_row_model.dart';
import '../models/report_sentences_model.dart';


class ApiService {
  static const String base_url = 'http://127.0.0.1:8000';

  // 한 페이지를 불러와야할 때
  // 필터결과에 해당하는 행 최대 10개
  static Future<List<OneRowModel>> outOnePage(int page, String filter_score, List<String> filter_industries, String filter_name) async {
    // final url = Uri.parse('$base_url/rank/page/');
    
    // final requestData = {
    //   'filter_score': filter_score,
    //   'filter_industries': filter_industries,
    //   'filter_name': filter_name,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<OneRowModel> rows_instances = [];
    
    // if (response.statusCode == 200) {
    //   final rows = jsonDecode(utf8.decode(response.bodyBytes));
    //   for (var row in rows) {
    //     final instance = OneRowModel.fromJson(row);
    //     rows_instances.add(instance);
    //   }
    //   return rows_instances;
    // }
    
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/one_row.json");

    List<OneRowModel> rows_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> rows = List<Map<String, dynamic>>.from(jsonData);
    
    for (var row in rows) {
      if (page <= row['pages_number']) {
      if (filter_score == "prism-ALL") {
        if (filter_industries.isNotEmpty){
          for (var industry in filter_industries) {
            if (row['industry'] == industry) {
              if (filter_name == "") {
                final instance = OneRowModel.fromJson(row);
                rows_instances.add(instance);
              }
              else {
                if (row['name'].toString().contains(filter_name)) {
                  final instance = OneRowModel.fromJson(row);
                  rows_instances.add(instance);
                }
              }
            }
          }
          
        }
        else
        {
          if (filter_name == "") {
                final instance = OneRowModel.fromJson(row);
                rows_instances.add(instance);
              }
              else {
                if (row['name'].toString().contains(filter_name)) {
                  final instance = OneRowModel.fromJson(row);
                  rows_instances.add(instance);
                }
              }
        }
      }
      }
    }
    
    return rows_instances;


    // 에러 처리
    throw Exception('Failed to fetch filtered data');
  }


  // 한 행(회사)의 년도를 선택해야할 때
  static Future<List<int>> outCompanyYears(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany/years/');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<int> yearsInstance = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body); // 예: [{"years": [2022, 2021]}]
      //years : List<int>
      var yearsDict = jsonData[0]; // {years: [2022, 2021]}
      for (var year in yearsDict["years"]) {
        final instance = year;
        yearsInstance.add(instance);
      }
      return yearsInstance;
    }
    // 에러 처리
    throw Exception('Failed to fetch company years');
  }


  // 한 행(회사)의 상세페이지 내용 필요
  static Future<List<Map<String, dynamic>>> outDetailPageInfo(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<Map<String, dynamic>> detail_page_infos = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(utf8.decode(response.bodyBytes));
    //   for (var score in scores) {
    //     final instance = score;
    //     detail_page_infos.add(instance);
    //   }
    //   return detail_page_infos;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch Detail Page Info');

    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/detail_page.json");

    List<Map<String, dynamic>> detail_page_infos = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> detail_pages = List<Map<String, dynamic>>.from(jsonData);

    for (var detail_page in detail_pages) {
      final instance = detail_page;
      detail_page_infos.add(instance);
    }
    return detail_page_infos;
  }

  // prism스코어, 존재하는 년도개수만큼
  static List<PrismScoreModel> outPrismScores(List<dynamic> data) {
    List<PrismScoreModel> prism_scores_instances = [];
    final List<Map<String, dynamic>> prism_scores = List<Map<String, dynamic>>.from(data);

    for (var prism_score in prism_scores) {
      final instance = PrismScoreModel.fromJson(prism_score);
      prism_scores_instances.add(instance);
    }
    return prism_scores_instances;
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static List<PrismIndAvgScoreModel> outPrismIndAvgScores(List<dynamic> data) {
    List<PrismIndAvgScoreModel> prism_ind_avg_scores_instances = [];
    final List<Map<String, dynamic>> prism_ind_avg_scores = List<Map<String, dynamic>>.from(data);

    for (var prism_ind_avg_score in prism_ind_avg_scores) {
      final instance = PrismIndAvgScoreModel.fromJson(prism_ind_avg_score);
      prism_ind_avg_scores_instances.add(instance);
    }
    return prism_ind_avg_scores_instances;
  }
  //kcgs스코어, 존재하는 년도 개수만큼
  static List<KcgsScoreModel> outKcgsScores(List<dynamic> data) {
    List<KcgsScoreModel> kcgs_scores_instances = [];
    final List<Map<String, dynamic>> kcgs_scores = List<Map<String, dynamic>>.from(data);

    for (var kcgs_score in kcgs_scores) {
      final instance = KcgsScoreModel.fromJson(kcgs_score);
      kcgs_scores_instances.add(instance);
    }
    return kcgs_scores_instances;
  }
  //esg연구소 스코어, 존재하는 년도 개수만큼
  static List<EsglabScoreModel> outEsglabScores(List<dynamic> data) {
    List<EsglabScoreModel> esglab_scores_instances = [];
    final List<Map<String, dynamic>> esglab_scores = List<Map<String, dynamic>>.from(data);

    for (var esglab_score in esglab_scores) {
      final instance = EsglabScoreModel.fromJson(esglab_score);
      esglab_scores_instances.add(instance);
    }
    return esglab_scores_instances;
  }
  //kcgs 평균스코어, 존재하는 년도 개수만큼
  static List<KcgsIndAvgScoreModel> outKcgsIndAvgScores(List<dynamic> data) {
    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores_instances = [];
    final List<Map<String, dynamic>> kcgs_ind_avg_scores = List<Map<String, dynamic>>.from(data);

    for (var kcgs_id_avg_scores in kcgs_ind_avg_scores) {
      final instance = KcgsIndAvgScoreModel.fromJson(kcgs_id_avg_scores);
      kcgs_ind_avg_scores_instances.add(instance);
    }
    return kcgs_ind_avg_scores_instances;
  }
  //esg연구소 평균 스코어, 존재하는 년도 개수만큼
  static List<EsglabIndAvgScoreModel> outEsglabIndAvgScores(List<dynamic> data) {
    List<EsglabIndAvgScoreModel> esglab_ind_avg_scores_instances = [];
    final List<Map<String, dynamic>> esglab_ind_avg_scores = List<Map<String, dynamic>>.from(data);

    for (var esglab_ind_avg_score in esglab_ind_avg_scores) {
      final instance = EsglabIndAvgScoreModel.fromJson(esglab_ind_avg_score);
      esglab_ind_avg_scores_instances.add(instance);
    }
    return esglab_ind_avg_scores_instances;
  }
  // 클릭한 회사 보고서 테이블, 존재하는 년도 개수만큼
  static List<SustainReportModel> outSustainReports(List<dynamic> data) {
    List<SustainReportModel> sustain_reports_instances = [];
    final List<Map<String, dynamic>> sustain_reports = List<Map<String, dynamic>>.from(data);

    for (var sustain_report in sustain_reports) {
      final instance = SustainReportModel.fromJson(sustain_report);
      sustain_reports_instances.add(instance);
    }
    return sustain_reports_instances;
  }
  //클릭한 회사 보고서가 사용한 gri정보, 최신년도만
  static List<GriInfoModel> outGriInfos(List<dynamic> data)  {
    List<GriInfoModel> gri_indexs_instances = [];
    final List<Map<String, dynamic>> gri_indexs = List<Map<String, dynamic>>.from(data);

    for (var gri_index in gri_indexs) {
      final instance = GriInfoModel.fromJson(gri_index);
      gri_indexs_instances.add(instance);
    }
    return gri_indexs_instances;
  }
  //클릭한 회사 보고서내 gri유사 문장, 최신년도만
  static List<ReportSentencesModel> outReportSentencess(List<dynamic> data)  {
    List<ReportSentencesModel> report_sentences_instances = [];
    final List<Map<String, dynamic>> report_sentences = List<Map<String, dynamic>>.from(data);

    for (var report_sentence in report_sentences) {
      final instance = ReportSentencesModel.fromJson(report_sentence);
      report_sentences_instances.add(instance);
    }
    return report_sentences_instances;
  }
  //클릭한 회사 보고서내 gri유사 테이블, 최신년도만
  static List<ReportTableModel> outReportTables(List<dynamic> data)  {
    List<ReportTableModel> report_tables_instances = [];
    final List<Map<String, dynamic>> report_tables = List<Map<String, dynamic>>.from(data);

    for (var report_table in report_tables) {
      final instance = ReportTableModel.fromJson(report_table);
      report_tables_instances.add(instance);
    }
    return report_tables_instances;
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static List<GriUsageIndAvgScoreModel> outGriUsageIndAvgScores(List<dynamic> data)  {
    List<GriUsageIndAvgScoreModel> gri_usage_ind_avg_scores_instances = [];
    final List<Map<String, dynamic>> gri_usage_ind_avg_scores = List<Map<String, dynamic>>.from(data);

    for (var gri_usage_ind_avg_score in gri_usage_ind_avg_scores) {
      final instance = GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
      gri_usage_ind_avg_scores_instances.add(instance);
    }
    return gri_usage_ind_avg_scores_instances;
  }


  // 비교페이지 내용 필요
  static Future<List<Map<String, dynamic>>> outComparingPageInfo(List<String> company_and_year) async {
    // final url = Uri.parse('$base_url/comparing/');
    // final requestData = {
    //   'company_and_year': company_and_year,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<Map<String, dynamic>> comparing_page_infos = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(utf8.decode(response.bodyBytes));
    //   for (var score in scores) {
    //     final instance = score;
    //     comparing_page_infos.add(instance);
    //   }
    //   return comparing_page_infos;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch Comparing Page Info');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/comparing_page.json");

    List<Map<String, dynamic>> comparing_page_infos = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> comparing_pages = List<Map<String, dynamic>>.from(jsonData);

    for (var comparing_page in comparing_pages) {
      final instance = comparing_page;
      comparing_page_infos.add(instance);
    }
    return comparing_page_infos;
  }

  // prism스코어, 해당하는 회사_년도 만큼
  static List<PrismScoreModel> outPrismScore(List<dynamic> data)  {
    List<PrismScoreModel> prism_scores_instances = [];
    final List<Map<String, dynamic>> prism_scores = List<Map<String, dynamic>>.from(data);

    for (var prism_score in prism_scores) {
      final instance = PrismScoreModel.fromJson(prism_score);
      prism_scores_instances.add(instance);
    }
    return prism_scores_instances;
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static List<PrismIndAvgScoreModel> outPrismIndAvgScore(List<dynamic> data)  {
    List<PrismIndAvgScoreModel> prism_ind_avg_scores_instances = [];
    final List<Map<String, dynamic>> prism_ind_avg_scores = List<Map<String, dynamic>>.from(data);

    for (var prism_ind_avg_score in prism_ind_avg_scores) {
      final instance = PrismIndAvgScoreModel.fromJson(prism_ind_avg_score);
      prism_ind_avg_scores_instances.add(instance);
    }
    return prism_ind_avg_scores_instances;
  }
  // kcgs스코어, 해당하는 회사_년도 만큼
  static List<KcgsScoreModel> outKcgsScore(List<dynamic> data)  {
    List<KcgsScoreModel> kcgs_scores_instances = [];
    final List<Map<String, dynamic>> kcgs_scores = List<Map<String, dynamic>>.from(data);

    for (var kcgs_score in kcgs_scores) {
      final instance = KcgsScoreModel.fromJson(kcgs_score);
      kcgs_scores_instances.add(instance);
    }
    return kcgs_scores_instances;
  }
  //esg연구소 스코어,해당하는 회사_년도 만큼
  static List<EsglabScoreModel> outEsglabScore(List<dynamic> data)  {
    List<EsglabScoreModel> esglab_scores_instances = [];
    final List<Map<String, dynamic>> esglab_scores = List<Map<String, dynamic>>.from(data);

    for (var esglab_score in esglab_scores) {
      final instance = EsglabScoreModel.fromJson(esglab_score);
      esglab_scores_instances.add(instance);
    }
    return esglab_scores_instances;
  }
  

  // 비교대상의 gri유사 문장 및 표 필요
  static Future<List<Map<String, dynamic>>> outComparingGriInfo(List<String> reports, List<String> gri_indexes) async {
    // final url = Uri.parse('$base_url/comparing/context/');
    // final requestData = {
    //   'reports': reports,
    //   'gri_indexes': gri_indexes,
    // };

    // List<ReportSentencesModel> comparing_gri_datas = [];
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // if (response.statusCode == 200) {
    //   final comparing_gris = jsonDecode(utf8.decode(response.bodyBytes));
    //   for (var comparing_gri in comparing_gris) {
    //     final instance = ReportSentencesModel.fromJson(comparing_gri);
    //     comparing_gri_datas.add(instance);
    //   }
    //   return comparing_gri_datas;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch Comparing Gri Info');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/comparing_gri.json");

    List<Map<String, dynamic>> comparing_gri_datas = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> comparing_gris = List<Map<String, dynamic>>.from(jsonData);

    for (var comparing_gri in comparing_gris) {
      final instance = comparing_gri;
      comparing_gri_datas.add(instance);
    }
    return comparing_gri_datas;
  }
  
  //클릭한 회사 보고서내 gri유사 문장, 해당하는 회사_년도 만큼
  static List<ReportSentencesModel> outReportSentences(List<dynamic> data)  {
    List<ReportSentencesModel> sentences_instances = [];
    final List<Map<String, dynamic>> sentences = List<Map<String, dynamic>>.from(data);

    for (var sentence in sentences) {
      final instance = ReportSentencesModel.fromJson(sentence);
      sentences_instances.add(instance);
    }
    return sentences_instances;
  }
  //클릭한 회사 보고서내 gri유사 테이블, 해당하는 회사_년도 만큼
  static List<ReportTableModel> outReportTable(List<dynamic> data)  {
    List<ReportTableModel> tables_instances = [];
    final List<Map<String, dynamic>> tables = List<Map<String, dynamic>>.from(data);

    for (var table in tables) {
      final instance = ReportTableModel.fromJson(table);
      tables_instances.add(instance);
    }
    return tables_instances;
  }
}