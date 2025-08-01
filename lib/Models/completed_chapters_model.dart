class CompletedChaptersModel {
  final int id;
  CompletedChaptersModel(this.id);

  factory CompletedChaptersModel.fromJson(Map<String, dynamic> json) {
    return CompletedChaptersModel(json["chapter_id"] ?? -1);
  }
}