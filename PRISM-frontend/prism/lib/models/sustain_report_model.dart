class SustainReport {
  final int sustain_report_id, year;
  final String download_link,
      industry,
      e_score,
      s_score,
      g_score,
      ind_e_score,
      ind_s_score,
      ind_g_score,
      company_id,
      gri_usage_score_id,
      gri_usage_ind_avg_id;

  SustainReport.fromJson(Map<String, dynamic> json)
      : sustain_report_id = json['Sustain_report_id'],
        year = json['Year'],
        download_link = json['Download_link'],
        industry = json['Industry'],
        e_score = json['E_score'],
        s_score = json['S_score'],
        g_score = json['G_score'],
        ind_e_score = json['Ind_e_score'],
        ind_s_score = json['Ind_s_score'],
        ind_g_score = json['Ind_g_score'],
        company_id = json['Company_id'],
        gri_usage_score_id = json['Gri_usage_score_id'],
        gri_usage_ind_avg_id = json['Gri_usage_ind_avg_id'];
}
