import 'language.dart';

class PrivacyPolicy {
  final String title;
  final String body;

  PrivacyPolicy({required this.title, required this.body});

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
        title: json['title_${Language.getLocaleCode()}'] ?? json['title_en'],
        body: json['body_${Language.getLocaleCode()}'] ?? json['body_en']);
  }
}
