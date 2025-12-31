import 'package:get/get.dart';

class AboutUs {
  final String title;
  final String description;

  AboutUs({required this.title, required this.description});

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    String? languageCode = Get.locale?.languageCode == 'es'
        ? 'tr'
        : Get.locale?.languageCode == 'it'
            ? 'or'
            : Get.locale?.languageCode;

    return AboutUs(
        title: json['title_$languageCode'],
        description: json['body_$languageCode']);
  }
}
