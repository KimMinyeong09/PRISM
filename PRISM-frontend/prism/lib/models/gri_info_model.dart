class GriInfoModel {
  final int sustain_report_id, gri_info_id, gri_index_id;

  GriInfoModel.fromJson(Map<String, dynamic> json)
      : sustain_report_id = json['Sustain_report_id'],
        gri_info_id = json['Gri_info_id'],
        gri_index_id = json['Gri_index_id'];
}
