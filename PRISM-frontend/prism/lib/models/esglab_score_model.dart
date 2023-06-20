class EsglabScoreModel {
  final String overallScore, EScore, SScore, GScore;
  final int esglabScoreId, evalYear, companyId, esglabIndAvgId;

  EsglabScoreModel.fromJson(Map<String, dynamic> json)
      : esglabScoreId = json['Esglab_score_id'],
        evalYear = json['Eval_year'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'],
        companyId = json['Company_id'],
        esglabIndAvgId = json['Esglab_ind_avg_id'];
}
