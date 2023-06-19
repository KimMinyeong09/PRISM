class PrismIndAvgScoreModel {
  final int prismIndAvgId,
      year,
      overallScore,
      EScore,
      SScore,
      GScore,
      wOverallScore,
      wEScore,
      wSScore,
      wGScore;
  final String industry;

  PrismIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : prismIndAvgId = json['Prism_ind_avg_id'],
        year = json['Year'],
        industry = json['Industry'],
        overallScore = json['Overall_score'],
        EScore = json['E_score'],
        SScore = json['S_score'],
        GScore = json['G_score'],
        wOverallScore = json['W_overall_score'],
        wEScore = json['W_e_score'],
        wSScore = json['W_s_score'],
        wGScore = json['W_g_score'];
}
