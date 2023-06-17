class IndWeightModel {
  final int indWeightId, year;
  final String industry;
  final double wieght;

  IndWeightModel.fromJson(Map<String, dynamic> json)
      : indWeightId = json['Ind_weight_id'],
        year = json['Year'],
        industry = json['Industry'],
        wieght = json['Weight'];
}
