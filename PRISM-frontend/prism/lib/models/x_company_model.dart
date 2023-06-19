class CompanyModel {
  final String name, industry;
  final int id;

  CompanyModel.fromJson(Map<String, dynamic> json)
      : id = json['Company_id'],
        name = json['Name'],
        industry = json['Industry'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'industry': industry,
      'id': id,
    };
  }
}
