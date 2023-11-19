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
    profile_picture: json['profilePicture'] as String?,
    emailVerifiedAt: json['emailVerifiedAt'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
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