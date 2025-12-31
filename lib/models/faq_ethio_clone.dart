import 'package:get/get.dart';

class FAQ {
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
    String? languageCode = Get.locale?.languageCode == 'es'
        ? 'tg'
        : Get.locale?.languageCode == 'it'
            ? 'or'
            : Get.locale?.languageCode == 'fr'
                ? 'so'
                : Get.locale?.languageCode;

    question = json['question_$languageCode'];
    answer = json['answer_$languageCode'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }
}
