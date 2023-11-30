class User{
  static late var profilePicture= null;
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
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String?,
    phone: json['phone_number'] as String?,
    profile_picture: json.containsKey(['profile_picture'])?json['profile_picture'] as String?:null,
    emailVerifiedAt: json.containsKey(['email_verified_at'])?json['email_verified_at'] as String?:null,
    createdAt: json.containsKey(['created_at'])?json['created_at'] as String?:null,
    updatedAt: json.containsKey(['updated_at'])?json['updated_at'] as String?:null,
  );
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