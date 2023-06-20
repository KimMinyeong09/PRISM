class EsglabScoreModel {
  final String overallScore, EScore, SScore, GScore;
  final int evalYear;

  EsglabScoreModel.fromJson(Map<String, dynamic> json)
      : 
        evalYear = json['eval_year'],
        overallScore = json['overall_score'],
        EScore = json['e_score'],
        SScore = json['s_score'],
        GScore = json['g_score'];
}
