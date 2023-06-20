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

class PrismScore {
  
}


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
    //   final rows = jsonDecode(response.body);
    //   for (var row in rows) {
    //     final instance = OneRowModel.fromJson(row);
    //     rows_instances.add(instance);
    //   }
    //   return rows_instances;
    // }
    
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/one_row.json");
    // final jsonString = await Future.wait([rootBundle.loadString("../../assets/dummyJSON/one_row.json"), rootBundle.loadString("../../assets/dummyJSON/prism_score.json"), rootBundle.loadString("../../assets/dummyJSON/prism_ind_avg_score.json")]);

    List<OneRowModel> rows_instances = [];

    final jsonData = jsonDecode(jsonString);
    // final jsonData = jsonDecode(jsonString[0]);
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
  // prism스코어, 존재하는 년도개수만큼
  static Future<List<PrismScoreModel>> outPrismScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<PrismScoreModel> prism_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = PrismScoreModel.fromJson(score);
    //     prism_scores.add(instance);
    //   }
    //   return prism_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company Prism scores');

    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/prism_score.json");
    // final jsonString = await Future.wait([rootBundle.loadString("../../assets/dummyJSON/one_row.json"), rootBundle.loadString("../../assets/dummyJSON/prism_score.json"), rootBundle.loadString("../../assets/dummyJSON/prism_ind_avg_score.json")]);

    List<PrismScoreModel> prism_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    // final jsonData = jsonDecode(jsonString[1]);
    final List<Map<String, dynamic>> prism_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var prism_score in prism_scores) {
      final instance = PrismScoreModel.fromJson(prism_score);
      prism_scores_instances.add(instance);
    }
    return prism_scores_instances;
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = PrismIndAvgScoreModel.fromJson(score);
    //     prism_ind_avg_scores.add(instance);
    //   }
    //   return prism_ind_avg_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch industry Prism scores');

    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/prism_ind_avg_score.json");

    List<PrismIndAvgScoreModel> prism_ind_avg_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> prism_ind_avg_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var prism_ind_avg_score in prism_ind_avg_scores) {
      final instance = PrismIndAvgScoreModel.fromJson(prism_ind_avg_score);
      prism_ind_avg_scores_instances.add(instance);
    }
    return prism_ind_avg_scores_instances;
  }
  //kcgs스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsScoreModel>> outKcgsScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<KcgsScoreModel> kcgs_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = KcgsScoreModel.fromJson(score);
    //     kcgs_scores.add(instance);
    //   }
    //   return kcgs_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company KCGS scores');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/kcgs_score.json");

    List<KcgsScoreModel> kcgs_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> kcgs_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var kcgs_score in kcgs_scores) {
      final instance = KcgsScoreModel.fromJson(kcgs_score);
      kcgs_scores_instances.add(instance);
    }
    return kcgs_scores_instances;
  }
  //esg연구소 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabScoreModel>> outEsglabScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<EsglabScoreModel> esglab_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = EsglabScoreModel.fromJson(score);
    //     esglab_scores.add(instance);
    //   }
    //   return esglab_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company ESGlab scores');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/esglab_score.json");

    List<EsglabScoreModel> esglab_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> esglab_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var esglab_score in esglab_scores) {
      final instance = EsglabScoreModel.fromJson(esglab_score);
      esglab_scores_instances.add(instance);
    }
    return esglab_scores_instances;
  }
  //kcgs 평균스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = KcgsIndAvgScoreModel.fromJson(score);
    //     kcgs_ind_avg_scores.add(instance);
    //   }
    //   return kcgs_ind_avg_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch industry KCGS average scores');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/kcgs_ind_avg_score.json");

    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> kcgs_ind_avg_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var kcgs_id_avg_scores in kcgs_ind_avg_scores) {
      final instance = KcgsIndAvgScoreModel.fromJson(kcgs_id_avg_scores);
      kcgs_ind_avg_scores_instances.add(instance);
    }
    return kcgs_ind_avg_scores_instances;
  }
  //esg연구소 평균 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<EsglabIndAvgScoreModel> esglab_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = EsglabIndAvgScoreModel.fromJson(score);
    //     esglab_scores.add(instance);
    //   }
    //   return esglab_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch industry ESGlab average scores');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/esglab_ind_avg_score.json");

    List<EsglabIndAvgScoreModel> esglab_ind_avg_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> esglab_ind_avg_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var esglab_ind_avg_score in esglab_ind_avg_scores) {
      final instance = EsglabIndAvgScoreModel.fromJson(esglab_ind_avg_score);
      esglab_ind_avg_scores_instances.add(instance);
    }
    return esglab_ind_avg_scores_instances;
  }
  // 클릭한 회사 보고서 테이블, 존재하는 년도 개수만큼
  static Future<List<SustainReportModel>> outSustainReports(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<SustainReportModel> esglab_scores = [];

    // if (response.statusCode == 200) {
    //   final reports = jsonDecode(response.body);
    //   for (var report in reports) {
    //     final instance = SustainReportModel.fromJson(report);
    //     esglab_scores.add(instance);
    //   }
    //   return esglab_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch sustain reports');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/sustain_report.json");

    List<SustainReportModel> sustain_reports_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> sustain_reports = List<Map<String, dynamic>>.from(jsonData);

    for (var sustain_report in sustain_reports) {
      final instance = SustainReportModel.fromJson(sustain_report);
      sustain_reports_instances.add(instance);
    }
    return sustain_reports_instances;
  }
  //클릭한 회사 보고서가 사용한 gri정보, 최신년도만
  static Future<List<GriInfoModel>> outGriInfos(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<GriInfoModel> gri_indexs = [];

    // if (response.statusCode == 200) {
    //   final gris = jsonDecode(response.body);
    //   for (var gri in gris) {
    //     final instance = GriInfoModel.fromJson(gri);
    //     gri_indexs.add(instance);
    //   }
    //   return gri_indexs;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch gri info of sustain report');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/gri_info.json");

    List<GriInfoModel> gri_indexs_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> gri_indexs = List<Map<String, dynamic>>.from(jsonData);

    for (var gri_index in gri_indexs) {
      final instance = GriInfoModel.fromJson(gri_index);
      gri_indexs_instances.add(instance);
    }
    return gri_indexs_instances;
  }
  //클릭한 회사 보고서내 gri유사 문장, 최신년도만
  static Future<List<ReportSentencesModel>> outReportSentencess(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<ReportSentencesModel> report_sentences_instances = [];

    // if (response.statusCode == 200) {
    //   final report_sentences = jsonDecode(response.body);
    //   for (var report_sentence in report_sentences) {
    //     final instance = ReportSentencesModel.fromJson(report_sentence);
    //     report_sentences_instances.add(instance);
    //   }
    //   return report_sentences_instances;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch gri info of sustain report');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/report_sentences.json");

    List<ReportSentencesModel> report_sentences_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> report_sentences = List<Map<String, dynamic>>.from(jsonData);

    for (var report_sentence in report_sentences) {
      final instance = ReportSentencesModel.fromJson(report_sentence);
      report_sentences_instances.add(instance);
    }
    return report_sentences_instances;
  }
  //클릭한 회사 보고서내 gri유사 테이블, 최신년도만
  static Future<List<ReportTableModel>> outReportTables(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<ReportTableModel> report_tables_instances = [];

    // if (response.statusCode == 200) {
    //   final report_tables = jsonDecode(response.body);
    //   for (var report_table in report_tables) {
    //     final instance = ReportTableModel.fromJson(report_table);
    //     report_tables_instances.add(instance);
    //   }
    //   return report_tables_instances;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch gri table info');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/report_table.json");

    List<ReportTableModel> report_tables_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> report_tables = List<Map<String, dynamic>>.from(jsonData);

    for (var report_table in report_tables) {
      final instance = ReportTableModel.fromJson(report_table);
      report_tables_instances.add(instance);
    }
    return report_tables_instances;
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<List<GriUsageIndAvgScoreModel>> outGriUsageIndAvgScores(String company) async {
    // final url = Uri.parse('$base_url/rank/oneCompany/');
  
    // final requestData = {
    //   'company': company,
    // };
    
    // final response = await http.post(url, body: requestData); 

    // List<GriUsageIndAvgScoreModel> gri_usage_ind_avg_scores = [];

    // if (response.statusCode == 200) {
    //   final reports = jsonDecode(response.body);
    //   for (var report in reports) {
    //     final instance = GriUsageIndAvgScoreModel.fromJson(report);
    //     gri_usage_ind_avg_scores.add(instance);
    //   }
    //   return gri_usage_ind_avg_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch gri rate of sustain report');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/gri_usage_ind_avg_score.json");

    List<GriUsageIndAvgScoreModel> gri_usage_ind_avg_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> gri_usage_ind_avg_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var gri_usage_ind_avg_score in gri_usage_ind_avg_scores) {
      final instance = GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
      gri_usage_ind_avg_scores_instances.add(instance);
    }
    return gri_usage_ind_avg_scores_instances;
  }

  // 비교페이지 내용 필요
  // prism스코어, 해당하는 회사_년도 만큼
  static Future<List<PrismScoreModel>> outPrismScore(List<Map<String, int>> company_and_year) async {
    // final url = Uri.parse('$base_url/comparing/');
    // final requestData = {
    //   'company_and_year': company_and_year,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<PrismScoreModel> prism_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = PrismScoreModel.fromJson(score);
    //     prism_scores.add(instance);
    //   }
    //   return prism_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company PRISM score');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/prism_score.json");

    List<PrismScoreModel> prism_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> prism_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var prism_score in prism_scores) {
      final instance = PrismScoreModel.fromJson(prism_score);
      prism_scores_instances.add(instance);
    }
    return prism_scores_instances;
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScore(List<Map<String, int>> company_and_year) async {
    // final url = Uri.parse('$base_url/comparing/');
    // final requestData = {
    //   'company_and_year': company_and_year,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = PrismIndAvgScoreModel.fromJson(score);
    //     prism_ind_avg_scores.add(instance);
    //   }
    //   return prism_ind_avg_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch industry PRISM score');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/prism_ind_avg_score.json");

    List<PrismIndAvgScoreModel> prism_ind_avg_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> prism_ind_avg_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var prism_ind_avg_score in prism_ind_avg_scores) {
      final instance = PrismIndAvgScoreModel.fromJson(prism_ind_avg_score);
      prism_ind_avg_scores_instances.add(instance);
    }
    return prism_ind_avg_scores_instances;
  }
  // kcgs스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsScoreModel>> outKcgsScore(List<Map<String, int>> company_and_year) async {
    // final url = Uri.parse('$base_url/comparing/');
    // final requestData = {
    //   'company_and_year': company_and_year,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<KcgsScoreModel> kcgs_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = KcgsScoreModel.fromJson(score);
    //     kcgs_scores.add(instance);
    //   }
    //   return kcgs_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company KCGS score');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/kcgs_score.json");

    List<KcgsScoreModel> kcgs_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> kcgs_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var kcgs_score in kcgs_scores) {
      final instance = KcgsScoreModel.fromJson(kcgs_score);
      kcgs_scores_instances.add(instance);
    }
    return kcgs_scores_instances;
  }
  //esg연구소 스코어,해당하는 회사_년도 만큼
  static Future<List<EsglabScoreModel>> outEsglabScore(List<Map<String, int>> company_and_year) async {
    // final url = Uri.parse('$base_url/comparing/');
    // final requestData = {
    //   'company_and_year': company_and_year,
    // };
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // List<EsglabScoreModel> esglab_scores = [];

    // if (response.statusCode == 200) {
    //   final scores = jsonDecode(response.body);
    //   for (var score in scores) {
    //     final instance = EsglabScoreModel.fromJson(score);
    //     esglab_scores.add(instance);
    //   }
    //   return esglab_scores;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch company esglab score');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/esglab_score.json");

    List<EsglabScoreModel> esglab_scores_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> esglab_scores = List<Map<String, dynamic>>.from(jsonData);

    for (var esglab_score in esglab_scores) {
      final instance = EsglabScoreModel.fromJson(esglab_score);
      esglab_scores_instances.add(instance);
    }
    return esglab_scores_instances;
  }
  // //회사 보고서 테이블 내용, 해당하는 회사_년도 만큼
  // static Future<List<SustainReportModel>> outSustainReport(List<Map<String, int>> company_and_year) async {
  //   final url = Uri.parse('$base_url/comparing/');
  //   final requestData = {
  //     'company_and_year': company_and_year,
  //   };
    
  //   final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

  //   List<SustainReportModel> report_instances = [];

  //   if (response.statusCode == 200) {
  //     final reports = jsonDecode(response.body);
  //     for (var report in reports) {
  //       final instance = SustainReportModel.fromJson(report);
  //       report_instances.add(instance);
  //     }
  //     return report_instances;
  //   }
  //   // 에러 처리
  //   throw Exception('Failed to fetch company sustain reports');
  // }

  // 비교대상의 gri유사 문장 및 표 필요
  //클릭한 회사 보고서내 gri유사 문장, 해당하는 회사_년도 만큼
  static Future<List<ReportSentencesModel>> outReportSentences(List<Map<String, int>> reports, List<String> gri_indexes) async {
    // final url = Uri.parse('$base_url/comparing/context/');
    // final requestData = {
    //   'reports': reports,
    //   'gri_indexes': gri_indexes,
    // };

    // List<ReportSentencesModel> sentences_instances = [];
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // if (response.statusCode == 200) {
    //   final sentences = jsonDecode(response.body);
    //   for (var sentence in sentences) {
    //     final instance = ReportSentencesModel.fromJson(sentence);
    //     sentences_instances.add(instance);
    //   }
    //   return sentences_instances;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch sentences of company sustain reports');

    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/report_sentences.json");

    List<ReportSentencesModel> sentences_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> sentences = List<Map<String, dynamic>>.from(jsonData);

    for (var sentence in sentences) {
      for (var gri_index in gri_indexes) {
        if (sentence['gri_index'] == gri_index) {
          final instance = ReportSentencesModel.fromJson(sentence);
          sentences_instances.add(instance);
        }
      }
      
    }
    return sentences_instances;
  }
  //클릭한 회사 보고서내 gri유사 테이블, 해당하는 회사_년도 만큼
  static Future<List<ReportTableModel>> outReportTable(List<Map<String, int>> reports, List<String> gri_indexes) async {
    // final url = Uri.parse('$base_url/comparing/context/');
    // final requestData = {
    //   'reports': reports,
    //   'gri_indexes': gri_indexes,
    // };
    
    // List<ReportTableModel> tables_instances = [];
    
    // final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

    // if (response.statusCode == 200) {
    //   final tables = jsonDecode(response.body);
    //   for (var table in tables) {
    //     final instance = ReportTableModel.fromJson(table);
    //     tables_instances.add(instance);
    //   }
    //   return tables_instances;
    // }
    // // 에러 처리
    // throw Exception('Failed to fetch table of company sustain reports');
    final jsonString = await rootBundle.loadString("../../assets/dummyJSON/report_table.json");

    List<ReportTableModel> tables_instances = [];

    final jsonData = jsonDecode(jsonString);
    final List<Map<String, dynamic>> tables = List<Map<String, dynamic>>.from(jsonData);

    for (var table in tables) {
      for (var gri_index in gri_indexes) {
        if (table['gri_index'] == gri_index) {
          final instance = ReportTableModel.fromJson(table);
          tables_instances.add(instance);
        }
      }
    }
    return tables_instances;
  }
  // //gri index사용 비율 업종 평균점수, 최신년도만
  // static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScore(List<Map<String, int>> reports, List<String> gri_indexes) async {
  //   final url = Uri.parse('$base_url/comparing/context/');
  //   final requestData = {
  //     'reports': reports,
  //     'gri_indexes': gri_indexes,
  //   };
    
  //   final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(requestData));

  //   if (response.statusCode == 200) {
  //     final gri_usage_ind_avg_score = jsonDecode(response.body);
  //     return GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
  //   }
  //   // 에러 처리
  //   throw Exception('Failed to fetch gri rate of company sustain reports');
  // }
}