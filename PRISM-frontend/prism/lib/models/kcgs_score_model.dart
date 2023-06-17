class KcgsScoreModel {
  final String overallScore, EScore, SScore, GScore;
  final int kcgsScroeId, evalYear, companyId, kcgsIndAvgId;

  KcgsScoreModel.fromJson(Map<String, dynamic> json)
      : kcgsScroeId = json['Kcgs_scroe_id'],
        evalYear = json['Eval_year'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'],
        companyId = json['Company_id'],
        kcgsIndAvgId = json['Kcgs_ind_avg_id'];
}
