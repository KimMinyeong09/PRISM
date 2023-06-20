class SustainReportModel {
  final int year, e_score,
      s_score,
      g_score;
  final String download_link;

  SustainReportModel.fromJson(Map<String, dynamic> json)
      : 
        year = json['year'],
        download_link = json['download_link'],
        e_score = json['e_score'],
        s_score = json['s_score'],
        g_score = json['g_score'];
}
