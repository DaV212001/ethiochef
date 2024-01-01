import '../utils/constants.dart';

class Contestant{
  int? id;
  String? firstName;
  String? lastName;
  int? votes;
  String? image;
  String? phone;

  Contestant(
      this.id,
      this.firstName,
      this.lastName,
      this.votes,
      this.image
      );
  // {id: 6, first_name: jonatham, last_name: zeru, phone_number: 0966274102, profile_picture: ../public_html/uploads/1702710701419-1000001825.jpg}, user_id: 6, votes: 0, created_at: 2023-12-26T18:30:55.797Z, updated_at: 2023-12-26T18:30:55.797Z, contest_id: 1}
  Contestant.fromJson (Map<String, dynamic> json ){
    print(json);
    String clearPath(String path) {
      final parts = path.split('/public_html');
      return parts.last;
    }
    String image = json['user']['profile_picture'];
    String i = clearPath(image);
    String thumbnail = Constants.ImageAPI + i;
    id = json['user']['id'];
    firstName = json['user']['first_name'] ;
    lastName =  json['user']['last_name'];
    phone = json['user']['phone_number'];
    votes = json['votes'];
    this.image = thumbnail;
  }
}