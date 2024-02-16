class UpdateManagerClass {
  int? id;
  String? latestVersionAndroid;
  String? minimumVersionAndroid;
  String? updateLinkAndroid;
  String? updateLinkIOS;
  String? latestVersionIOS;
  String? minimumVersionIOS;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  UpdateManagerClass({
    this.id,
    this.latestVersionAndroid,
    this.minimumVersionAndroid,
    this.updateLinkAndroid,
    this.updateLinkIOS,
    this.latestVersionIOS,
    this.minimumVersionIOS,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateManagerClass.fromJson(Map<String, dynamic> json) => UpdateManagerClass(
    id: json["id"],
    latestVersionAndroid: json["latest_version_android"],
    minimumVersionAndroid: json["minimum_version_android"],
    updateLinkAndroid: json["update_link_android"],
    updateLinkIOS: json["update_link_ios"],
    latestVersionIOS: json["latest_version_ios"],
    minimumVersionIOS: json["minimum_version_ios"],
    isDeleted: json["is_deleted"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latest_version_android": latestVersionAndroid,
    "minimum_version_android": minimumVersionAndroid,
    "update_link_android": updateLinkAndroid,
    "update_link_ios": updateLinkIOS,
    "latest_version_ios": latestVersionIOS,
    "minimum_version_ios": minimumVersionIOS,
    "is_deleted": isDeleted,
    "created_at": createdAt,
    "updated_at": updatedAt
  };
}