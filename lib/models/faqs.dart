import 'language.dart';

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
    question = json['question'][Language.getLocaleCode()] ?? json['question']['en'];
    answer = json['answer'][Language.getLocaleCode()] ?? json['answer']['en'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }
}