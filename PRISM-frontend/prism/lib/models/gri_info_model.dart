class GriInfoModel {
  final String gri_index;

  GriInfoModel.fromJson(Map<String, dynamic> json)
      : gri_index = json['gri_index'];
}
