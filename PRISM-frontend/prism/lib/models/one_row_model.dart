class OneRowModel {
  final String name, industry;
  final int score, pages_number;
  final List<dynamic> esg_insts;

  OneRowModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        industry = json['industry'],
        score = json['score'],
        esg_insts = json['esg_insts'],
        pages_number = json['pages_number'];
}
