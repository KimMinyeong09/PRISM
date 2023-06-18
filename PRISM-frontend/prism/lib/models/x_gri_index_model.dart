class GriIndexModel {
  final int gri_index_id;
  final String major_num,
      major_name,
      middle_num,
      middle_name,
      sub_num,
      sub_name;

  GriIndexModel.fromJson(Map<String, dynamic> json)
      : gri_index_id = json['Gri_index_id'],
        major_num = json['Major_num'],
        major_name = json['Major_name'],
        middle_num = json['Middle_num'],
        middle_name = json['Middle_name'],
        sub_num = json['Sub_num'],
        sub_name = json['Sub_name'];
}
