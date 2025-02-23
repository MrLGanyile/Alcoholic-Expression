// Collection Name /alcoholics/{alcoholicId}
import '../locations/converter.dart';

import '../locations/section_name.dart';
import 'user.dart';

// Collection Name /alcoholics/alcoholicId
// groups_crud -> group_resources_crud ->  create_group_resources_front_end
class Alcoholic extends User {
  SectionName sectionName;
  String username;
  String? groupFK; // The Group To Which This User Belong To.

  Alcoholic(
      {required phoneNumber,
      required profileImageURL,
      required this.sectionName,
      required this.username,
      required password,
      this.groupFK})
      : super(
            phoneNumber: phoneNumber,
            profileImageURL: profileImageURL,
            password: password);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();

    map.addAll({
      'sectionName': Converter.asString(sectionName),
      'username': username,
      'groupFK': groupFK,
    });

    return map;
  }

  factory Alcoholic.fromJson(dynamic json) => Alcoholic(
      profileImageURL: json['profileImageURL'],
      phoneNumber: json['phoneNumber'],
      sectionName: Converter.toSectionName(json['sectionName']),
      username: json['username'],
      groupFK: json['groupFK'],
      password: json['password']);
}
