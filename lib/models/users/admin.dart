import 'user.dart';

class Admin extends User {
  bool isSuperiorAdmin;
  String key;
  bool isFemale;

  Admin(
      {required phoneNumber,
      required profileImageURL,
      required this.isFemale,
      required this.isSuperiorAdmin,
      required password,
      required this.key})
      : super(
            phoneNumber: phoneNumber,
            profileImageURL: profileImageURL,
            password: password);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();

    map.addAll(
        {'isSuperiorAdmin': isSuperiorAdmin, 'key': key, 'isFemale': isFemale});

    return map;
  }

  factory Admin.fromJson(dynamic json) => Admin(
      phoneNumber: json['phoneNumber'],
      profileImageURL: json['profileImageURL'],
      isFemale: json['isFemale'],
      isSuperiorAdmin: json['isSuperiorAdmin'],
      password: json['password'],
      key: json['key']);
}
