class GriUsageIndAvgScoreModel {
  final int year, E_score, S_score, G_score;

  GriUsageIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      :
        year = json['year'],
        E_score = json['e_score'],
        S_score = json['s_score'],
        G_score = json['g_score'];
}
