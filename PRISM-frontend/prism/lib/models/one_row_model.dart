class OneRowModel {
  final String name;
  final int industry, score, pages_number;
  final List<String> esg_insts;

  OneRowModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        industry = json['industry'],
        score = json['industry'],
        esg_insts = json['esg_insts'],
        pages_number = json['pages_number'];
}
