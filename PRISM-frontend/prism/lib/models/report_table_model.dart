class ReportTableModel {
  final int sustain_report_id, gri_info_id, report_table_id, sim_rank, page;
  final String title, Html_code;

  ReportTableModel.fromJson(Map<String, dynamic> json)
      : sustain_report_id = json['Sustain_report_id'],
        gri_info_id = json['Gri_info_id'],
        report_table_id = json['Report_table_id'],
        sim_rank = json['Sim_rank'],
        title = json['Title'],
        Html_code = json['Html_code'],
        page = json['Page'];
}
