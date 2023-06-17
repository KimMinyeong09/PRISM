class EsglabIndAvgScoreModel {
  final int esglabIndAvgId, year;
  final String industry, overallScore, EScore, SScore, GScore;
  final double wieght;

  EsglabIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : esglabIndAvgId = json['Esglab_ind_avg_id'],
        year = json['Year'],
        industry = json['Industry'],
        wieght = json['Weight'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'];
}
