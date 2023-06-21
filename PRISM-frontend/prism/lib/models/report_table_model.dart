class ReportTableModel {
  final int sim_rank, page;
  final String gri_index, link;

  ReportTableModel.fromJson(Map<String, dynamic> json)
      : gri_index = json['gri_index'],
        sim_rank = json['sim_rank'],
        link = json['html_code'],
        page = json['page_num'];
}
