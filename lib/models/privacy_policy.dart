import 'package:get/get.dart';

class PrivacyPolicy {
  final String title;
  final String body;

  PrivacyPolicy({required this.title, required this.body});

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    String? languageCode = Get.locale?.languageCode == 'es'
        ? 'tg'
        : Get.locale?.languageCode == 'it'
            ? 'or'
            : Get.locale?.languageCode == 'fr'
                ? 'so'
                : Get.locale?.languageCode;

    return PrivacyPolicy(
        title: json['title_$languageCode'], body: json['body_$languageCode']);
  }
}
