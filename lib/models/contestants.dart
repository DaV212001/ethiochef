import '../utils/constants.dart';

class Contestant{
  int? id;
  String? firstName;
  String? lastName;
  int? votes;
  String? image;
  String? phone;
  String? video;

  Contestant(
      this.id,
      this.firstName,
      this.lastName,
      this.votes,
      this.image,
      this.video
      );
  Contestant.fromJson (Map<String, dynamic> json ){
    print(json);
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['profile_picture'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    id = json['id'];
    firstName = json['name'];
    video = json['video'];
    lastName =  "";
    phone = "";
    votes = json['vote'];
    this.image = thumbnail;
  }
}