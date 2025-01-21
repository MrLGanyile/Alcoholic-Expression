// Branch : user_models_creation
abstract class User {
  String phoneNumber;
  String profileImageURL;

  User({
    required this.phoneNumber,
    required this.profileImageURL,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'phoneNumber': phoneNumber,
      'profileImageURL': profileImageURL,
    });
    return map;
  }
}
