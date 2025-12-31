class Tutor {
  final int id;
  final String fullName;
  final String profileImage;
  final String cityName;
  final String phone;
  final String description;
  final String yearOfExperience;
  final String gender;

  Tutor({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.cityName,
    required this.phone,
    required this.description,
    required this.yearOfExperience,
    required this.gender,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      cityName: json['city_name'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      yearOfExperience: json['year_of_experiance'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}
