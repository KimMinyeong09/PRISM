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
  static const String base_url = '../../assets/dummyJSOM'; // url 변경

  // static Future<List<CompanyModel>> outCompany(
  //     List<String> industries, String search) async {
  //   List<CompanyModel> companyInstances = [];
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final companies = jsonDecode(response.body);
  //     for (var company in companies) {
  //       final instance = CompanyModel.fromJson(company);
  //       if (industries.isEmpty || industries.contains(instance.industry)) {
  //         if (search == "" || instance.name.contains(search)) {
  //           companyInstances.add(instance);
  //         }
  //       }
  //     }
  //     return companyInstances;
  //   }
  //   throw Error();
  // }

  // static Future<int?> outCompanyId(String name) async {
  //   final response = await http.get(Uri.parse(url));
  //   int? id;
  //   if (response.statusCode == 200) {
  //     final company = jsonDecode(response.body);
  //     id = CompanyModel.fromJson(company).id;
  //     return id;
  //   } else {
  //     return null;
  //   }
  // }

  // static Future<KcgsScoreModel?> outKcgsScore(int? companyId) async {
  //   if (companyId != null) {
  //     final response = await http
  //         .get(Uri.parse("./../assets/kcgs_score/$companyId")); //TODO: url 수정
  //     if (response.statusCode == 200) {
  //       final kcgsScore = jsonDecode(response.body);
  //       return KcgsScoreModel.fromJson(kcgsScore);
  //     } else {
  //       return null;
  //     }
  //   }
  //   return null;
  //   // throw Error();
  // }

  // static Future<EsglabScoreModel?> outEsglabScore(int? companyId) async {
  //   if (companyId != null) {
  //     final response = await http
  //         .get(Uri.parse("./../assets/esglab_score/$companyId")); //TODO: url 수정
  //     if (response.statusCode == 200) {
  //       final esglabScore = jsonDecode(response.body);
  //       return EsglabScoreModel.fromJson(esglabScore);
  //     } else {
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  // static Future<PrismScoreModel> outPrismScore(int? companyId) async {
  //   final response = await http.get(Uri.parse(base_url));
  //   if (response.statusCode == 200) {
  //     final prismScore = jsonDecode(response.body);
  //     return PrismScoreModel.fromJson(prismScore);
  //   }
  //   throw Error();
  // }

  // static Future<PrismScoreModel?> outPrismScoreByCompanyName(
  //     String companyName) async {
  //   final companyId = await outCompanyId(companyName);

  //   if (companyId != null) {
  //     final prismScore = await outPrismScore(companyId);
  //     return prismScore;
  //   }

  //   return null;
  // }

  // static Future<List<SustainReport>> outSustainReport(int companyId) async {
  //   List<SustainReport> reportInstances = [];
  //   final response = await http
  //       .get(Uri.parse("./../assets/sustain_report/1.json")); // TODO: 수정
  //   if (response.statusCode == 200) {
  //     final reports = jsonDecode(response.body);
  //     for (var report in reports) {
  //       final instance = SustainReport.fromJson(report);
  //       if (instance.company_id == companyId.toString()) {
  //         reportInstances.add(instance);
  //       }
  //     }
  //     return reportInstances;
  //   }

  //   throw Error();
  // }

  // 한 페이지를 불러와야할 때
  // 필터결과에 해당하는 행 최대 10개
  static Future<List<OneRowModel>> outOnePage(int page, String filter_score, List<String> filter_industries, String filter_name) async {
    final url = Uri.parse('$base_url/rank/$page');
    final response = await http.get(url);

    List<OneRowModel> rows_instances = [];

    if (response.statusCode == 200) {
      final rows = jsonDecode(response.body);
      for (var row in rows) {
        final instance = OneRowModel.fromJson(row);
        rows_instances.add(instance);
      }
      return rows_instances;
    }
    throw Error();
  }

  // 한 행(회사)의 년도를 선택해야할 때
  // 선택한 회사에 해당하는 년도 - 이렇게 하는게 맞을까요?
  static Future<List<int>> outCompanyYears(String company) async {
    final url = Uri.parse('$base_url/rank/$company/years');
    final response = await http.get(url);

    List<int> year = [];

    if (response.statusCode == 200) {
      final year = jsonDecode(response.body);
      return year;
    }
    throw Error();
  }

  // 한 행(회사)의 상세페이지 내용 필요
  // prism스코어, 존재하는 년도개수만큼
  static Future<List<PrismScoreModel>> outPrismScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<PrismScoreModel> prism_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prism_scores.add(instance);
      }
      return prism_scores;
    }
    throw Error();

  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prism_ind_avg_scores.add(instance);
      }
      return prism_ind_avg_scores;
    }
    throw Error();
  }
  //kcgs스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsScoreModel>> outKcgsScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<KcgsScoreModel> kcgs_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgs_scores.add(instance);
      }
      return kcgs_scores;
    }
    throw Error();
  }
  //esg연구소 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabScoreModel>> outEsglabScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<EsglabScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }
  //kcgs 평균스코어, 존재하는 년도 개수만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgs_ind_avg_scores.add(instance);
      }
      return kcgs_ind_avg_scores;
    }
    throw Error();
  }
  //esg연구소 평균 스코어, 존재하는 년도 개수만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<EsglabIndAvgScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }
  // 클릭한 회사 보고서 테이블, 존재하는 년도 개수만큼
  static Future<List<SustainReportModel>> outSustainReports(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    List<SustainReportModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }
  //클릭한 회사 보고서가 사용한 gri정보, 최신년도만
  static Future<GriInfoModel> outGriInfos(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return GriInfoModel.fromJson(gri_info);
    }
    throw Error();
  }
  //클릭한 회사 보고서내 gri유사 문장, 최신년도만
  static Future<ReportSentencesModel> outReportSentencess(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(gri_info);
    }
    throw Error();
  }
  //클릭한 회사 보고서내 gri유사 테이블, 최신년도만
  static Future<ReportTableModel> outReportTables(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final report_table = jsonDecode(response.body);
      return ReportTableModel.fromJson(report_table);
    }
    throw Error();
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScores(String company) async {
    final url = Uri.parse('$base_url/rank/$company');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final gri_usage_ind_avg_score = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
    }
    throw Error();
  }

  // 비교페이지 내용 필요
  // prism스코어, 해당하는 회사_년도 만큼
  static Future<List<PrismScoreModel>> outPrismScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<PrismScoreModel> prism_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismScoreModel.fromJson(score);
        prism_scores.add(instance);
      }
      return prism_scores;
    }
    throw Error();

  }
  //특정 업종의 prism스코어, 존재하는 년도 개수 만큼
  static Future<List<PrismIndAvgScoreModel>> outPrismIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<PrismIndAvgScoreModel> prism_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = PrismIndAvgScoreModel.fromJson(score);
        prism_ind_avg_scores.add(instance);
      }
      return prism_ind_avg_scores;
    }
    throw Error();
  }
  // kcgs스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsScoreModel>> outKcgsScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<KcgsScoreModel> kcgs_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsScoreModel.fromJson(score);
        kcgs_scores.add(instance);
      }
      return kcgs_scores;
    }
    throw Error();
  }
  //esg연구소 스코어,해당하는 회사_년도 만큼
  static Future<List<EsglabScoreModel>> outEsglabScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<EsglabScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }
  //kcgs 평균스코어, 해당하는 회사_년도 만큼
  static Future<List<KcgsIndAvgScoreModel>> outKcgsIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<KcgsIndAvgScoreModel> kcgs_ind_avg_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = KcgsIndAvgScoreModel.fromJson(score);
        kcgs_ind_avg_scores.add(instance);
      }
      return kcgs_ind_avg_scores;
    }
    throw Error();
  }
  //esg연구소 평균 스코어, 해당하는 회사_년도 만큼
  static Future<List<EsglabIndAvgScoreModel>> outEsglabIndAvgScore(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<EsglabIndAvgScoreModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final scores = jsonDecode(response.body);
      for (var score in scores) {
        final instance = EsglabIndAvgScoreModel.fromJson(score);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }
  //회사 보고서 테이블 내용, 해당하는 회사_년도 만큼
  static Future<List<SustainReportModel>> outSustainReport(List<Map<String, int>> company_and_year) async {
    final url = Uri.parse('$base_url/comparing');
    final response = await http.get(url);

    List<SustainReportModel> esglab_scores = [];

    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReportModel.fromJson(report);
        esglab_scores.add(instance);
      }
      return esglab_scores;
    }
    throw Error();
  }

  // 비교대상의 gri유사 문장 및 표 필요
  //클릭한 회사 보고서내 gri유사 문장, 해당하는 회사_년도 만큼
  static Future<ReportSentencesModel> outReportSentences(List<Map<int, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final gri_info = jsonDecode(response.body);
      return ReportSentencesModel.fromJson(gri_info);
    }
    throw Error();
  }
  //클릭한 회사 보고서내 gri유사 테이블, 해당하는 회사_년도 만큼
  static Future<ReportTableModel> outReportTable(List<Map<int, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final report_table = jsonDecode(response.body);
      return ReportTableModel.fromJson(report_table);
    }
    throw Error();
  }
  //gri index사용 비율 업종 평균점수, 최신년도만
  static Future<GriUsageIndAvgScoreModel> outGriUsageIndAvgScore(List<Map<int, int>> reports, List<String> gri_indexes) async {
    final url = Uri.parse('$base_url/comparing/context');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final gri_usage_ind_avg_score = jsonDecode(response.body);
      return GriUsageIndAvgScoreModel.fromJson(gri_usage_ind_avg_score);
    }
    throw Error();
  }
}
