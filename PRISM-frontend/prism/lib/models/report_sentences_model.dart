class ReportSentencesModel {
  final int sustain_report_id,
      gri_info_id,
      report_senetences_id,
      sim_rank,
      page;
  final String most_sentence, preced_sentences, back_sentences;

  ReportSentencesModel.fromJson(Map<String, dynamic> json)
      : sustain_report_id = json['Sustain_report_id'],
        gri_info_id = json['Gri_info_id'],
        report_senetences_id = json['Report_senetences_id'],
        sim_rank = json['Sim_rank'],
        most_sentence = json['Most_sentence'],
        preced_sentences = json['Preced_sentences'],
        back_sentences = json['Back_sentences'],
        page = json['Page'];
}
