class PrismIndAvgScoreModel {
  final int 
      year,
      overallScore,
      EScore,
      SScore,
      GScore,
      wOverallScore,
      wEScore,
      wSScore,
      wGScore;


  PrismIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : 
        year = json['eval_year'],
        overallScore = json['overall_score'],
        EScore = json['e_score'],
        SScore = json['s_score'],
        GScore = json['g_score'],
        wOverallScore = json['w_overall_score'],
        wEScore = json['w_e_score'],
        wSScore = json['w_s_score'],
        wGScore = json['w_g_score'];
}
