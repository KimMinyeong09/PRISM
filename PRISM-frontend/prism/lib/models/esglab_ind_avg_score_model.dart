class EsglabIndAvgScoreModel {
  final int esglabIndAvgId, year, industry;
  final String overallScore, EScore, SScore, GScore;

  EsglabIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : esglabIndAvgId = json['Esglab_score_id'],
        year = json['Year'],
        industry = json['Industry'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'];
}
