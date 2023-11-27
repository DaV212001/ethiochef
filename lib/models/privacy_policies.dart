class PrivacyPolicy{
  final String title;
  final String body;

  PrivacyPolicy({
    required this.title,
    required this.body
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
        title: json['title'],
        body: json['body']
    );
  }
}