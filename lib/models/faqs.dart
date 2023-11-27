class FAQ{
  int? id;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;

  FAQ({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  FAQ.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }
}