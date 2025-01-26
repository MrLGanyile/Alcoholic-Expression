// Branch : group_resources_crud ->  create_group_resources_front_end
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
