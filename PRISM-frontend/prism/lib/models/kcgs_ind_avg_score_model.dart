class KcgsIndAvgScoreModel {
  final int kcgsIndAvgId, year, industry;
  final String overallScore, EScore, SScore, GScore;

  KcgsIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : kcgsIndAvgId = json['Kcgs_ind_avg_id'],
        year = json['Year'],
        industry = json['Industry'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'];
}
