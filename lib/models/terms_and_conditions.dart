import 'package:ethio_chef/models/language.dart';

class TermsAndConditions {
  final String title;
  final String body;

  TermsAndConditions({required this.title, required this.body});

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
        title: json['title_${Language.getLocaleCode()}'] ?? json['title_en'],
        body: json['body_${Language.getLocaleCode()}'] ?? json['body_en']);
  }
}
