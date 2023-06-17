class KcgsIndAvgScoreModel {
  final int kcgsIndAvgId, year;
  final String industry, overallScore, EScore, SScore, GScore;
  final double wieght;

  KcgsIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : kcgsIndAvgId = json['Kcgs_ind_avg_id '],
        year = json['Year'],
        industry = json['Industry'],
        wieght = json['Weight'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'];
}
