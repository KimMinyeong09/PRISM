import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prism/models/prism_score_model.dart';

import '../models/company_model.dart';
import '../models/esglab_score_model.dart';
import '../models/kcgs_score_model.dart';
import '../models/sustain_report_model.dart';

class ApiService {
  static const String url = '../../assets/company_data.json'; // url 변경

  static Future<List<CompanyModel>> outCompany(
      List<String> industries, String search) async {
    List<CompanyModel> companyInstances = [];
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final companies = jsonDecode(response.body);
      for (var company in companies) {
        final instance = CompanyModel.fromJson(company);
        if (industries.isEmpty || industries.contains(instance.industry)) {
          if (search.isEmpty || instance.name.contains(search)) {
            companyInstances.add(instance);
          }
        }
      }
      return companyInstances;
    }
    throw Error();
  }

  static Future<int?> outCompanyId(String name) async {
    final response = await http.get(Uri.parse(url));
    int? id;
    if (response.statusCode == 200) {
      final company = jsonDecode(response.body);
      id = CompanyModel.fromJson(company).id;
      return id;
    } else {
      return null;
    }
  }

  static Future<KcgsScoreModel?> outKcgsScore(int? companyId) async {
    if (companyId != null) {
      final response = await http
          .get(Uri.parse("./../assets/kcgs_score/$companyId")); //TODO: url 수정
      if (response.statusCode == 200) {
        final kcgsScore = jsonDecode(response.body);
        return KcgsScoreModel.fromJson(kcgsScore);
      } else {
        return null;
      }
    }
    return null;
    // throw Error();
  }

  static Future<EsglabScoreModel?> outEsglabScore(int? companyId) async {
    if (companyId != null) {
      final response = await http
          .get(Uri.parse("./../assets/esglab_score/$companyId")); //TODO: url 수정
      if (response.statusCode == 200) {
        final esglabScore = jsonDecode(response.body);
        return EsglabScoreModel.fromJson(esglabScore);
      } else {
        return null;
      }
    }
    return null;
  }

  static Future<PrismScoreModel> outPrismScore(int companyId) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final prismScore = jsonDecode(response.body);
      return PrismScoreModel.fromJson(prismScore);
    }
    throw Error();
  }

  static Future<List<SustainReport>> outSustainReport(int companyId) async {
    List<SustainReport> reportInstances = [];
    final response = await http
        .get(Uri.parse("./../assets/sustain_report/1.json")); // TODO: 수정
    if (response.statusCode == 200) {
      final reports = jsonDecode(response.body);
      for (var report in reports) {
        final instance = SustainReport.fromJson(report);
        if (instance.company_id == companyId.toString()) {
          reportInstances.add(instance);
        }
      }
      return reportInstances;
    }

    throw Error();
  }
}
