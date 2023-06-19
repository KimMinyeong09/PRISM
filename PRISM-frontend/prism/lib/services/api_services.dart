import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prism/models/gri_info_model.dart';
import 'package:prism/models/prism_ind_avg_score_model.dart';
import 'package:prism/models/prism_score_model.dart';
import 'package:prism/models/report_table_model.dart';
import 'package:prism/models/sustain_report_model.dart';

// import '../models/x_company_model.dart';
// import '../models/esglab_score_model.dart';
// import '../models/kcgs_score_model.dart';
// import '../models/sustain_report_model.dart';
import '../models/esglab_ind_avg_score_model.dart';
import '../models/esglab_score_model.dart';
import '../models/gri_usage_ind_avg_score_model.dart';
import '../models/kcgs_ind_avg_score_model.dart';
import '../models/kcgs_score_model.dart';
import '../models/one_row_model.dart';
import '../models/report_sentences_model.dart';

class ApiService {
  static const String base_url = '../../assets/dummyJSOM'; // TODO: url 변경

  // 한 페이지를 불러와야할 때
  // 필터결과에 해당하는 행 최대 10개
  static Future<List<OneRowModel>> outOnePage(int page, String filter_score, List<String> filter_industries, String filter_name) async {
    final url = Uri.parse('$base_url/rank/$page');
    
    final requestData = {
      'filter_score': filter_score,
      'filter_industries': filter_industries,
      'filter_name': filter_name,
    };
    
    final response = await http.post(url, body: jsonEncode(requestData));

    List<OneRowModel> rows_instances = [];
    
    if (response.statusCode == 200) {
      final rows = jsonDecode(response.body);
      for (var row in rows) {
        final instance = OneRowModel.fromJson(row);
        rows_instances.add(instance);
      }
      return rows_instances;
    }
    // 에러 처리
    throw Exception('Failed to fetch filtered data');
  }

  // 한 행(회사)의 년도를 선택해야할 때
  // 선택한 회사에 해당하는 년도 - 이렇게 하는게 맞을까요?
  static Future<List<int>> outCompanyYears(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany/years');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<int> yearsInstance = [];

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body); // 예: [{years: [2022, 2021]}]
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
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<PrismScoreModel> prism_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prism_scores.add(instance);
      }
      return prism_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company Prism scores');
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prism_ind_avg_scores.add(instance);
      }
      return prism_ind_avg_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry Prism scores');
  }
  //kcgs스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsScoreModel>> outKcgsScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<KcgsScoreModel> kcgs_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgs_scores.add(instance);
      }
      return kcgs_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company KCGS scores');
  }
  //esg연구소 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabScoreModel>> outEsglabScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<EsglabScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company ESGlab scores');
  }
  //kcgs 평균스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgs_ind_avg_scores.add(instance);
      }
      return kcgs_ind_avg_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry KCGS average scores');
  }
  //esg연구소 평균 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<EsglabIndAvgScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry ESGlab average scores');
  }
  // 클릭한 회사 보고서 테이블, 존재하는 년도 개수만큼
  static Future<List<SustainReportModel>> outSustainReports(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    List<SustainReportModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch sustain reports');
  }
  //클릭한 회사 보고서가 사용한 gri정보, 최신년도만
  static Future<GriInfoModel> outGriInfos(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return GriInfoModel.fromJson(gri_info);
    }
    // 에러 처리
    throw Exception('Failed to fetch gri info of sustain report');
  }
  //클릭한 회사 보고서내 gri유사 문장, 최신년도만
  static Future<ReportSentencesModel> outReportSentencess(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(gri_info);
    }
    // 에러 처리
    throw Exception('Failed to fetch gri sentences of sustain report');
  }
  //클릭한 회사 보고서내 gri유사 테이블, 최신년도만
  static Future<ReportTableModel> outReportTables(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final report_table = jsonDecode(response.body);
      return ReportTableModel.fromJson(report_table);
    }
    // 에러 처리
    throw Exception('Failed to fetch gri table of sustain report');
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');
  
    final requestData = {
      'company': company,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final gri_usage_ind_avg_score = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
    }
    // 에러 처리
    throw Exception('Failed to fetch gri rate of sustain report');
  }

  // 비교페이지 내용 필요
  // prism스코어, 해당하는 회사_년도 만큼
  static Future<List<PrismScoreModel>> outPrismScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<PrismScoreModel> prism_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prism_scores.add(instance);
      }
      return prism_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company PRISM score');
  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prism_ind_avg_scores.add(instance);
      }
      return prism_ind_avg_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry PRISM score');
  }
  // kcgs스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsScoreModel>> outKcgsScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<KcgsScoreModel> kcgs_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgs_scores.add(instance);
      }
      return kcgs_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company KCGS score');
  }
  //esg연구소 스코어,해당하는 회사_년도 만큼
  static Future<List<EsglabScoreModel>> outEsglabScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<EsglabScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch company esglab score');
  }
  //kcgs 평균스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgs_ind_avg_scores.add(instance);
      }
      return kcgs_ind_avg_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry KCGS average score');
  }
  //esg연구소 평균 스코어, 해당하는 회사_년도 만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<EsglabIndAvgScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    // 에러 처리
    throw Exception('Failed to fetch industry esglab average score');
  }
  //회사 보고서 테이블 내용, 해당하는 회사_년도 만큼
  static Future<List<SustainReportModel>> outSustainReport(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': company_and_year,
    };
    
    final response = await http.post(url, body: requestData); 

    List<SustainReportModel> report_instances = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        report_instances.add(instance);
      }
      return report_instances;
    }
    // 에러 처리
    throw Exception('Failed to fetch company sustain reports');
  }

  // 비교대상의 gri유사 문장 및 표 필요
  //클릭한 회사 보고서내 gri유사 문장, 해당하는 회사_년도 만큼
  static Future<ReportSentencesModel> outReportSentences(List<Map<String, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': gri_indexes,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(gri_info);
    }
    // 에러 처리
    throw Exception('Failed to fetch sentences of company sustain reports');
  }
  //클릭한 회사 보고서내 gri유사 테이블, 해당하는 회사_년도 만큼
  static Future<ReportTableModel> outReportTable(List<Map<String, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': gri_indexes,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final report_table = jsonDecode(response.body);
      return ReportTableModel.fromJson(report_table);
    }
    // 에러 처리
    throw Exception('Failed to fetch table of company sustain reports');
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScore(List<Map<String, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': gri_indexes,
    };
    
    final response = await http.post(url, body: requestData); 

    if (response.statusCode == 200) {
      final gri_usage_ind_avg_score = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
    }
    // 에러 처리
    throw Exception('Failed to fetch gri rate of company sustain reports');
  }
}
