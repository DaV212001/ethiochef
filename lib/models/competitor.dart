class Competitor{
  String? fullName;
  int? votes;
  String? image;

  Competitor(
      this.fullName,
      this.votes,
      this.image
      );

  Competitor.fromJson (Map<String, dynamic> json ){
    fullName = json['full_name'];
    votes = json['votes'];
    image = json['image'];
  }
}