import '../models/language.dart';

class TermsAndConditions{
  final String title;
  final String body;

  TermsAndConditions({
    required this.title,
    required this.body
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
        title: json['title'][Language.getLocaleCode()] ?? json['title']['en'],
        body: json['body'][Language.getLocaleCode()] ?? json['body']['en']
    );
  }
}