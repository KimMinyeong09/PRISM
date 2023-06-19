class GriUsageIndAvgScoreModel {
  final int gri_usage_ind_avg_id, year, E_score, S_score, G_score;
  final String industry;

  GriUsageIndAvgScoreModel.fromJson(Map<String, dynamic> json)
      : gri_usage_ind_avg_id = json['Gri_usage_ind_avg_id'],
        year = json['Year'],
        industry = json['Industry'],
        E_score = json['E_score'],
        S_score = json['S_score'],
        G_score = json['G_score'];
}
