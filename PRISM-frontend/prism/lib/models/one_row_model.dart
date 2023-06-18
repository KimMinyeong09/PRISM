class OneRowModel {
  final String name;
  final int industry, score, id;
  final List<String> esg_insts;

  OneRowModel.fromJson(Map<String, dynamic> json)
      : id = json['Company_id'],
        name = json['name'],
        industry = json['industry'],
        score = json['industry'],
        esg_insts = json['esg_insts'];
}
