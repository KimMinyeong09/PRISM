class EsglabIndAvgScoreModel {
  final int year;
  final String overallScore, EScore, SScore, GScore;

  EsglabIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : 
        year = json['year'],
        overallScore = json['overall_score'],
        EScore = json['e_score'],
        SScore = json['s_score'],
        GScore = json['g_score'];
}
