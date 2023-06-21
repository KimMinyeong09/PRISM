class ReportSentencesModel {
  final int sim_rank, page;
  final String gri_index, most_sentences, preced_sentences, back_sentences;

  ReportSentencesModel.fromJson(Map<String, dynamic> json)
      : gri_index = json['gri_index'],
        sim_rank = json['sim_rank'],
        most_sentences = json['most_sentences'],
        preced_sentences = json['preced_sentences'],
        back_sentences = json['back_sentences'],
        page = json['page_num'];
}