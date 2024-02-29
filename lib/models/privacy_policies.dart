import 'language.dart';

class PrivacyPolicy{
  final String title;
  final String body;

  PrivacyPolicy({
    required this.title,
    required this.body
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
        title: json['title'][Language.getLocaleCode()] ?? json['title']['en'],
        body: json['body'][Language.getLocaleCode()] ?? json['body']['en']
    );
  }
}