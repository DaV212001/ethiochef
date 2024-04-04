import '../utils/constants.dart';

class User{
  int? id;
  String firstName;
  String lastName;
  String? email;
  String? phone;
  String? profile_picture;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {
        required this.firstName,
        required this.lastName,
        this.email,
        this.phone,
        this.id,
        this.profile_picture,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {

    String profile_picture = "";
      if(json['profile_picture'] !=null){
        String clearPath(String path) {
          final parts = path.split('/public_html');
          return parts.last;
        }
        String image = json['profile_picture'];
        print("image $image");
        String i = clearPath(image);
        profile_picture = Constants.ImageAPI + i;
        print("profile_picture $profile_picture");
      }
      var profile_image = null;
      if(profile_picture == ""){
        profile_image = null;
      }else{
        profile_image = profile_picture;
      }
    return User(
    id: json['id'] as int?,
    firstName: json.containsKey('first_name')? json['first_name'] as String : '',
    lastName: json.containsKey('last_name')? json['last_name'] as String : '',
    email: json['email'] as String?,
    phone: json['phone_number'] as String?,
    profile_picture: profile_image,
    emailVerifiedAt: json.containsKey(['email_verified_at'])?json['email_verified_at'] as String?:null,
    createdAt: json.containsKey(['created_at'])?json['created_at'] as String?:null,
    updatedAt: json.containsKey(['updated_at'])?json['updated_at'] as String?:null,
    );
  }
  // {
  // "first_name": "Mohammed",
  // "last_name": "Ibrahim",
  // "phone_number":"0946410664"
  // }
  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phone
  };
  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'first_name': firstName,
  //   'last_name': lastName,
  //   'email': email,
  //   'phone_number': phone,
  //   'profilePicture': profilePicture,
  //   'emailVerifiedAt': emailVerifiedAt,
  //   'createdAt': createdAt,
  //   'updatedAt': updatedAt,
  // };

}