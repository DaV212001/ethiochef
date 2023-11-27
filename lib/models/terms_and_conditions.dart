class TermsAndConditions{
  final String title;
  final String body;

  TermsAndConditions({
    required this.title,
    required this.body
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
        title: json['title'],
        body: json['body']
    );
  }
}