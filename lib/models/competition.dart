import 'package:ethio_chef/models/competitor.dart';

class Competition {
  String name;
  String description;
  String image;
  int votes;
  int daysLeft;
  String? video;
  List<Competitor> competitor;

  Competition(
      {required this.name,
      required this.description,
      required this.image,
      required this.daysLeft,
      required this.votes,
      this.video,
      required this.competitor});
}
