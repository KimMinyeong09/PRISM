class KcgsIndAvgScoreModel {
  final int year;
  final String overallScore, EScore, SScore, GScore;

  KcgsIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : 
        year = json['eval_year'],
        overallScore = json['overall_score'],
        EScore = json['e_score'],
        SScore = json['s_score'],
        GScore = json['g_score'];
}
