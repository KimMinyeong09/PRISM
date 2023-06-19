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
  static const String base_url = 'http://127.0.0.1:8000'; // TODO: url 변경

  // 한 페이지를 불러와야할 때
  // 필터결과에 해당하는 행 최대 10개
  static Future<List<OneRowModel>> outOnePage(int page, String filterScore,
      List<String> filterIndustries, String filterName) async {
    final url = Uri.parse('$base_url/rank/$page');

    final requestData = {
      'filter_score': filterScore,
      'filter_industries': filterIndustries,
      'filter_name': filterName,
    };

    final response = await http.post(url, body: jsonEncode(requestData));

    List<OneRowModel> rowsInstances = [];

    if (response.statusCode == 200) {
      final rows = jsonDecode(response.body);
      for (var row in rows) {
        final instance = OneRowModel.fromJson(row);
        rowsInstances.add(instance);
      }
      return rowsInstances;
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

    // if (response.statusCode == 200) {
    //   final responseData = jsonDecode(response.body);
    //   if (responseData is List) {
    //     return List<int>.from(responseData);
    //   }
    // }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      //years : List<int>
      var yearsDict = jsonData[0];
      print(yearsDict);
      for (var year in yearsDict["years"]) {
        print(year);
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

    List<PrismScoreModel> prismScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prismScores.add(instance);
      }
      return prismScores;
    }
    // 예외 처리
    throw Exception('Failed to fetch company Prism scores');
  }

  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScores(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<PrismIndAvgScoreModel> prismIndAvgScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prismIndAvgScores.add(instance);
      }
      return prismIndAvgScores;
    }
    throw Error();
  }

  //kcgs스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsScoreModel>> outKcgsScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<KcgsScoreModel> kcgsScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgsScores.add(instance);
      }
      return kcgsScores;
    }
    throw Error();
  }

  //esg연구소 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabScoreModel>> outEsglabScores(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<EsglabScoreModel> esglabScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  //kcgs 평균스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScores(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<KcgsIndAvgScoreModel> kcgsIndAvgScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgsIndAvgScores.add(instance);
      }
      return kcgsIndAvgScores;
    }
    throw Error();
  }

  //esg연구소 평균 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScores(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<EsglabIndAvgScoreModel> esglabScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  // 클릭한 회사 보고서 테이블, 존재하는 년도 개수만큼
  static Future<List<SustainReportModel>> outSustainReports(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    List<SustainReportModel> esglabScores = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  //클릭한 회사 보고서가 사용한 gri정보, 최신년도만
  static Future<GriInfoModel> outGriInfos(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final griInfo = jsonDecode(response.body);
      return GriInfoModel.fromJson(griInfo);
    }
    throw Error();
  }

  //클릭한 회사 보고서내 gri유사 문장, 최신년도만
  static Future<ReportSentencesModel> outReportSentencess(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final griInfo = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(griInfo);
    }
    throw Error();
  }

  //클릭한 회사 보고서내 gri유사 테이블, 최신년도만
  static Future<ReportTableModel> outReportTables(String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final reportTable = jsonDecode(response.body);
      return ReportTableModel.fromJson(reportTable);
    }
    throw Error();
  }

  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScores(
      String company) async {
    final url = Uri.parse('$base_url/rank/oneCompany');

    final requestData = {
      'company': company,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final griUsageIndAvgScore = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(griUsageIndAvgScore);
    }
    throw Error();
  }

  // 비교페이지 내용 필요
  // prism스코어, 해당하는 회사_년도 만큼
  static Future<List<PrismScoreModel>> outPrismScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<PrismScoreModel> prismScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prismScores.add(instance);
      }
      return prismScores;
    }
    throw Error();
  }

  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<PrismIndAvgScoreModel> prismIndAvgScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prismIndAvgScores.add(instance);
      }
      return prismIndAvgScores;
    }
    throw Error();
  }

  // kcgs스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsScoreModel>> outKcgsScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<KcgsScoreModel> kcgsScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgsScores.add(instance);
      }
      return kcgsScores;
    }
    throw Error();
  }

  //esg연구소 스코어,해당하는 회사_년도 만큼
  static Future<List<EsglabScoreModel>> outEsglabScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<EsglabScoreModel> esglabScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  //kcgs 평균스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<KcgsIndAvgScoreModel> kcgsIndAvgScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgsIndAvgScores.add(instance);
      }
      return kcgsIndAvgScores;
    }
    throw Error();
  }

  //esg연구소 평균 스코어, 해당하는 회사_년도 만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScore(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<EsglabIndAvgScoreModel> esglabScores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  //회사 보고서 테이블 내용, 해당하는 회사_년도 만큼
  static Future<List<SustainReportModel>> outSustainReport(
      List<Map<String, int>> companyAndYear) async {
    final url = Uri.parse('$base_url/comparing');
    final requestData = {
      'company_and_year': companyAndYear,
    };

    final response = await http.post(url, body: requestData);

    List<SustainReportModel> esglabScores = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        esglabScores.add(instance);
      }
      return esglabScores;
    }
    throw Error();
  }

  // 비교대상의 gri유사 문장 및 표 필요
  //클릭한 회사 보고서내 gri유사 문장, 해당하는 회사_년도 만큼
  static Future<ReportSentencesModel> outReportSentences(
      List<Map<int, int>> reports, List<String> griIndexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': griIndexes,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final griInfo = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(griInfo);
    }
    throw Error();
  }

  //클릭한 회사 보고서내 gri유사 테이블, 해당하는 회사_년도 만큼
  static Future<ReportTableModel> outReportTable(
      List<Map<int, int>> reports, List<String> griIndexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': griIndexes,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final reportTable = jsonDecode(response.body);
      return ReportTableModel.fromJson(reportTable);
    }
    throw Error();
  }

  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScore(
      List<Map<int, int>> reports, List<String> griIndexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final requestData = {
      'reports': reports,
      'gri_indexes': griIndexes,
    };

    final response = await http.post(url, body: requestData);

    if (response.statusCode == 200) {
      final griUsageIndAvgScore = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(griUsageIndAvgScore);
    }
    throw Error();
  }
}
