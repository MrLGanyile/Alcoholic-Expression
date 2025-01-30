import '../locations/section_name.dart';
import 'dart:math';

import '../locations/converter.dart';

// Collection Name /groups
// groups_crud -> group_resources_crud ->  create_group_resources_front_end
class Group implements Comparable<Group> {
  String groupName;
  String get name => groupName;

  String groupImageURL;
  String get imageURL => groupImageURL;

  SectionName groupSectionName;
  SectionName get sectionName => groupSectionName;

  String groupSpecificArea;
  String get specificArea => groupSpecificArea;

  String groupCreatorPhoneNumber;
  String get creatorPhoneNumber => groupCreatorPhoneNumber;

  String groupCreatorImageURL;
  String get creatorImageURL => groupCreatorImageURL;

  String groupCreatorUsername;
  String get creatorUsername => groupCreatorUsername;

  bool isActive; // A group is active if it has atleast 10 members.
  bool get active => isActive;

  int maxNoOfMembers; // 5
  int get maximumNoOfMembers => maxNoOfMembers;

  List<String> groupMembers;
  List<String> get members => groupMembers;

  Group({
    required this.groupName,
    required this.groupImageURL,
    required this.groupSectionName,
    required this.groupSpecificArea,
    required this.groupCreatorPhoneNumber,
    required this.groupCreatorImageURL,
    required this.groupCreatorUsername,
    required this.groupMembers,
    this.isActive = false,
    required this.maxNoOfMembers,
  });

  Map<String, dynamic> toJson() => {
        'groupName': groupName,
        'groupImageURL': groupImageURL,
        'groupCreatorPhoneNumber': groupCreatorPhoneNumber,
        'groupSectionName': Converter.asString(groupSectionName),
        'groupSpecificArea': groupSpecificArea,
        'groupCreatorUsername': groupCreatorUsername,
        'groupCreatorImageURL': groupCreatorImageURL,
        'groupMembers': groupMembers,
        'isActive': isActive,
        'maxNoOfMembers': maxNoOfMembers,
      };

  factory Group.fromJson(dynamic json) => Group(
      groupName: json['groupName'],
      groupImageURL: json['groupImageURL'],
      groupSectionName: Converter.toSectionName(json['groupSectionName']),
      groupSpecificArea: json['groupSpecificArea'],
      groupCreatorPhoneNumber: json['groupCreatorPhoneNumber'],
      groupCreatorImageURL: json['groupCreatorImageURL'],
      groupMembers: toListOfStrings(json['groupMembers']),
      isActive: json['isActive'],
      maxNoOfMembers: json['maxNoOfMembers'],
      groupCreatorUsername: json['groupCreatorUsername']);

  @override
  int compareTo(Group other) {
    return Converter.asString(groupSectionName)
        .compareTo(Converter.asString(other.groupSectionName));
  }

  bool removeMember(String memberPhoneNumber) {
    if (memberPhoneNumber.compareTo(groupCreatorPhoneNumber) != 0 &&
        groupMembers.length > 1) {
      groupMembers.remove(memberPhoneNumber);
      return true;
    } else {
      return false;
    }
  }

  bool addMember(String memberPhoneNumber) {
    if (memberPhoneNumber.compareTo(groupCreatorPhoneNumber) != 0 &&
        groupMembers.length < maxNoOfMembers) {
      groupMembers.add(memberPhoneNumber);
      return true;
    } else {
      return false;
    }
  }
}

List<String> toListOfStrings(List<dynamic> members) {
  List<String> list = [];

  for (int i = 0; i < members.length; i++) {
    list.add(members[i].toString());
  }
  return list;
}
