import 'dart:io';
import 'dart:developer' as debug;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/locations/converter.dart';
import '../models/locations/section_name.dart';
import '../models/users/alcoholic.dart';
import '../models/users/group.dart';
import 'share_dao_functions.dart';

enum GroupSavingStatus {
  incorrectData,
  incompleteData,
  loginRequired,
  alreadyCreatedGroup,
  saved,
}

enum GroupUpdatingStatus {
  loginRequired,
  destinationGroupFilled,
  groupDeletionRequired,
  unathourized,
  updated,
}

// Branch : group_resources_crud ->  group_crud_data_access
class GroupController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instance;
  final storage = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  final auth = FirebaseAuth.instance;

  static GroupController instance = Get.find();

  Rx<bool> _hasPickedGroupSectionName = Rx<bool>(false);
  bool get hasPickedGroupSectionName => _hasPickedGroupSectionName.value;

  void setHasPickedGroupSectionName(bool hasPickedGroupSectionName) {
    _hasPickedGroupSectionName = Rx<bool>(hasPickedGroupSectionName);
  }

  late Rx<File?> _groupImageFile;
  File? get groupImageFile => _groupImageFile.value;
  late Rx<String?> _groupImageURL = Rx('');
  String? get groupImageURL => _groupImageURL.value;
  late Rx<String?> _groupName = Rx('');
  String? get groupName => _groupName.value;
  late Rx<SectionName?> _groupSectionName =
      Rx(SectionName.howardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica);
  SectionName? get groupSectionName => _groupSectionName.value;
  late Rx<String?> _groupSpecificArea = Rx('');
  String? get groupSpecificArea => _groupSpecificArea.value;
  late Rx<bool> _isActive; // A group is active if it has atleast 10 members.
  bool get isActive => _isActive.value;
  Rx<int> _maxNoOfMembers = Rx(5);
  int get maxNoOfMembers => _maxNoOfMembers.value;

  late Rx<File?> _member1ProfileImageFile;
  File? get member1ProfileImageFile => _member1ProfileImageFile.value;
  late Rx<String?> _member1ImageURL = Rx('');
  String? get member1ImageURL => _member1ImageURL.value;
  late Rx<String?> _member1PhoneNumber = Rx('');
  String? get member1PhoneNumber => _member1PhoneNumber.value;
  late Rx<String?> _member1Username = Rx('');
  String? get member1Username => _member1Username.value;

  late Rx<File?> _member2ProfileImageFile;
  File? get member2ProfileImageFile => _member2ProfileImageFile.value;
  late Rx<String?> _member2ImageURL = Rx('');
  String? get member2ImageURL => _member2ImageURL.value;
  late Rx<String?> _member2PhoneNumber = Rx('');
  String? get member2PhoneNumber => _member2PhoneNumber.value;
  late Rx<String?> _member2Username = Rx('');
  String? get member2Username => _member2Username.value;

  late Rx<File?> _member3ProfileImageFile;
  File? get member3ProfileImageFile => _member3ProfileImageFile.value;
  late Rx<String?> _member3ImageURL = Rx('');
  String? get member3ImageURL => _member3ImageURL.value;
  late Rx<String?> _member3PhoneNumber = Rx('');
  String? get member3PhoneNumber => _member3PhoneNumber.value;
  late Rx<String?> _member3Username = Rx('');
  String? get member3Username => _member3Username.value;

  late Rx<File?> _member4ProfileImageFile;
  File? get member4ProfileImageFile => _member4ProfileImageFile.value;
  late Rx<String?> _member4ImageURL = Rx('');
  String? get member4ImageURL => _member4ImageURL.value;
  late Rx<String?> _member4PhoneNumber = Rx('');
  String? get member4PhoneNumber => _member4PhoneNumber.value;
  late Rx<String?> _member4Username = Rx('');
  String? get member4Username => _member4Username.value;

  late Rx<File?> _leaderProfileImageFile;
  File? get leaderProfileImageFile => _leaderProfileImageFile.value;
  late Rx<String?> _leaderImageURL = Rx('');
  String? get leaderImageURL => _leaderImageURL.value;
  late Rx<String?> _leaderPhoneNumber = Rx('');
  String? get leaderPhoneNumber => _leaderPhoneNumber.value;
  late Rx<String?> _leaderUsername = Rx('');
  String? get leaderUsername => _leaderUsername.value;

  void clearAll() {
    _groupImageFile = Rx(null);
    _groupImageURL = Rx('');
    _groupName = Rx('');

    _groupSpecificArea = Rx('');
    _isActive = Rx(true);

    _member1ProfileImageFile = Rx(null);
    _member1ImageURL = Rx('');
    _member1PhoneNumber = Rx('');
    _member1Username = Rx('');

    _member2ProfileImageFile = Rx(null);
    _member2ImageURL = Rx('');
    _member2PhoneNumber = Rx('');
    _member2Username = Rx('');

    _member3ProfileImageFile = Rx(null);
    _member3ImageURL = Rx('');
    _member3PhoneNumber = Rx('');
    _member3Username = Rx('');

    _member4ProfileImageFile = Rx(null);
    _member4ImageURL = Rx('');
    _member4PhoneNumber = Rx('');
    _member4Username = Rx('');

    _leaderProfileImageFile = Rx(null);
    _leaderImageURL = Rx('');
    _leaderPhoneNumber = Rx('');
    _leaderUsername = Rx('');
  }

  void chooseMemberProfileImageFromGallery(
      int memberIndex, String phoneNumber, String username) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Picking An Image.');
    } else if (username.isEmpty) {
      Get.snackbar('Error', 'Username Is Required Before Picking An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImageFile != null) {
        switch (memberIndex) {
          case 1:
            _member1ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member1ImageURL = Rx<String?>(await uploadResource(
                _member1ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member1PhoneNumber = Rx<String?>(phoneNumber);
            _member1Username = Rx<String?>(username);
            break;
          case 2:
            _member2ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member2ImageURL = Rx<String?>(await uploadResource(
                _member2ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member2PhoneNumber = Rx<String?>(phoneNumber);
            _member2Username = Rx<String?>(username);
            break;
          case 3:
            _member3ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member3ImageURL = Rx<String?>(await uploadResource(
                _member3ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member3PhoneNumber = Rx<String?>(phoneNumber);
            _member3Username = Rx<String?>(username);
            break;
          case 4:
            _member4ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member4ImageURL = Rx<String?>(await uploadResource(
                _member4ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member4PhoneNumber = Rx<String?>(phoneNumber);
            _member4Username = Rx<String?>(username);
            break;
          default:
            _leaderProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _leaderImageURL = Rx<String?>(await uploadResource(
                _leaderProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _leaderPhoneNumber = Rx<String?>(phoneNumber);
            _leaderUsername = Rx<String?>(username);
        }
        Get.snackbar('Image Status', 'Image File Successfully Picked.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Picked.');
      }
    }
  }

  void captureMemberProfileImageFromCamera(
      int memberIndex, String phoneNumber, String username) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Capturing An Image.');
    } else if (username.isEmpty) {
      Get.snackbar('Error', 'Username Is Required Before Capturing An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImageFile != null) {
        switch (memberIndex) {
          case 1:
            _member1ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member1ImageURL = Rx<String?>(await uploadResource(
                _member1ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member1PhoneNumber = Rx<String?>(phoneNumber);
            _member1Username = Rx<String?>(username);
            break;
          case 2:
            _member2ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member2ImageURL = Rx<String?>(await uploadResource(
                _member2ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member2PhoneNumber = Rx<String?>(phoneNumber);
            _member2Username = Rx<String?>(username);
            break;
          case 3:
            _member3ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member3ImageURL = Rx<String?>(await uploadResource(
                _member3ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member3PhoneNumber = Rx<String?>(phoneNumber);
            _member3Username = Rx<String?>(username);
            break;
          case 4:
            _member4ProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _member4ImageURL = Rx<String?>(await uploadResource(
                _member4ProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _member4PhoneNumber = Rx<String?>(phoneNumber);
            _member4Username = Rx<String?>(username);
            break;
          default:
            _leaderProfileImageFile = Rx<File?>(File(pickedImageFile.path));
            _leaderImageURL = Rx<String?>(await uploadResource(
                _leaderProfileImageFile.value!,
                '/alcoholics/profile_images/$phoneNumber'));
            _leaderPhoneNumber = Rx<String?>(phoneNumber);
            _leaderUsername = Rx<String?>(username);
        }
        Get.snackbar('Image Status', 'Image File Successfully Captured.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Captured.');
      }
    }
  }

  void setGroupSectionName(String chosenSectionName) {
    _groupSectionName =
        Rx<SectionName?>(Converter.toSectionName(chosenSectionName));
    update();
  }

  void setMaxNoOfMembers(int noOfMembers) {
    if (noOfMembers >= 3) {
      _maxNoOfMembers = Rx<int>(noOfMembers);
    }
  }

  void setIsActive(bool isActive) {
    _isActive = Rx<bool>(isActive);
  }

  void chooseGroupImageFromGallery(
    String groupName,
    SectionName sectionName,
    String groupSpecificArea,
  ) async {
    if (groupName.isEmpty) {
      Get.snackbar('Error', 'Group Name Is Missing.');
    } else if (groupSpecificArea.isEmpty) {
      Get.snackbar('Error', 'Group Specific Area Is Missing.');
    } else if (_leaderPhoneNumber.value == null) {
      Get.snackbar('Error', 'Group Leaders\'s Phone Number Is Missing.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImageFile != null) {
        debug.log('Image Chosen Using Gallery');
        // Share the chosen image file on Getx State Management.
        _groupImageFile = Rx<File?>(File(pickedImageFile.path));

        _groupImageURL = Rx<String?>(await uploadResource(
            _groupImageFile.value!,
            '/groups_specific_locations/${_leaderPhoneNumber.value}'));
        _groupName = Rx<String?>(groupName);
        _groupSectionName = Rx<SectionName?>(sectionName);
        _groupSpecificArea = Rx<String?>(groupSpecificArea);

        Get.snackbar('Image Status', 'Image File Successfully Picked.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Picked.');
        update();
      }
    }
  }

  void captureGroupImageWithCamera(
    String groupName,
    SectionName sectionName,
    String groupSpecificArea,
  ) async {
    if (groupName.isEmpty) {
      debug.log('Group Name Is Empty.');
      Get.snackbar('Error', 'Group Name Is Missing.');
    } else if (groupSpecificArea.isEmpty) {
      debug.log('Group Specific Area Is Empty.');
      Get.snackbar('Error', 'Group Specific Area Is Missing.');
    } else if (_leaderPhoneNumber.value == null) {
      debug.log('Group Leader\'s Phone Number Is Empty Is Empty.');
      Get.snackbar('Error', 'Group Leaders\'s Phone Number Is Missing.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImageFile != null) {
        // Share the chosen image file on Getx State Management.
        _groupImageFile = Rx<File?>(File(pickedImageFile.path));

        _groupImageURL = Rx<String?>(await uploadResource(
            _groupImageFile.value!,
            '/groups_specific_locations/${_leaderPhoneNumber.value}'));
        _groupName = Rx<String>(groupName);
        _groupSectionName = Rx<SectionName?>(sectionName);
        _groupSpecificArea = Rx<String>(groupSpecificArea);

        Get.snackbar('Image Status', 'Image File Successfully Picked.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Picked.');
      }
    }
  }

  Future<void> createGroup1() async {
    final httpCallable = functions.httpsCallable('createGroup1');

    const data = {
      'param1': 1,
      'param2': 2,
    };

    final result = await httpCallable.call(data);

    debug.log(result.data.toString());
  }

  bool hasMember(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return member1ProfileImageFile != null &&
            _member1ImageURL.value != null &&
            _member1PhoneNumber.value != null &&
            _member1Username.value != null;
      case 2:
        return member2ProfileImageFile != null &&
            _member2ImageURL.value != null &&
            _member2PhoneNumber.value != null &&
            _member2Username.value != null;
      case 3:
        return member3ProfileImageFile != null &&
            _member3ImageURL.value != null &&
            _member3PhoneNumber.value != null &&
            _member3Username.value != null;
      case 4:
        return member4ProfileImageFile != null &&
            _member4ImageURL.value != null &&
            _member4PhoneNumber.value != null &&
            _member4Username.value != null;
      default:
        return leaderProfileImageFile != null &&
            _leaderImageURL.value != null &&
            _leaderPhoneNumber.value != null &&
            _leaderUsername.value != null;
    }
  }

  int countMember() {
    int count = 0;

    if (leaderPhoneNumber != null &&
        leaderUsername != null &&
        leaderProfileImageFile != null) {
      count++;
    }

    if (member1PhoneNumber != null &&
        member1Username != null &&
        member1ProfileImageFile != null) {
      count++;
    }

    if (member2PhoneNumber != null &&
        member2Username != null &&
        member2ProfileImageFile != null) {
      count++;
    }

    if (member3PhoneNumber != null &&
        member3Username != null &&
        member3ProfileImageFile != null) {
      count++;
    }

    if (member4PhoneNumber != null &&
        member4Username != null &&
        member4ProfileImageFile != null) {
      count++;
    }

    return count;
  }

  bool allValidPhoneNumbers() {
    switch (countMember()) {
      case 1:
        return isValidPhoneNumber(leaderPhoneNumber!);

      case 2:
        return isValidPhoneNumber(leaderPhoneNumber!) &&
            isValidPhoneNumber(member1PhoneNumber!);
      case 3:
        return isValidPhoneNumber(leaderPhoneNumber!) &&
            isValidPhoneNumber(member1PhoneNumber!) &&
            isValidPhoneNumber(member2PhoneNumber!);
      case 4:
        return isValidPhoneNumber(leaderPhoneNumber!) &&
            isValidPhoneNumber(member1PhoneNumber!) &&
            isValidPhoneNumber(member2PhoneNumber!) &&
            isValidPhoneNumber(member3PhoneNumber!);
      default:
        return isValidPhoneNumber(leaderPhoneNumber!) &&
            isValidPhoneNumber(member1PhoneNumber!) &&
            isValidPhoneNumber(member2PhoneNumber!) &&
            isValidPhoneNumber(member3PhoneNumber!) &&
            isValidPhoneNumber(member4PhoneNumber!);
    }
  }

  String trimmedImageURL(int index) {
    switch (index) {
      case 0:
        return _leaderImageURL.value!
            .substring(_leaderImageURL.value!.indexOf('/alcoholics'),
                _leaderImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
      case 1:
        return _member1ImageURL.value!
            .substring(_member1ImageURL.value!.indexOf('/alcoholics'),
                _member1ImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
      case 2:
        return _member2ImageURL.value!
            .substring(_member2ImageURL.value!.indexOf('/alcoholics'),
                _member2ImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
      case 3:
        return _member3ImageURL.value!
            .substring(_member3ImageURL.value!.indexOf('/alcoholics'),
                _member3ImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
      case 4:
        return _member4ImageURL.value!
            .substring(_member4ImageURL.value!.indexOf('/alcoholics'),
                _member4ImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
      default:
        return _groupImageURL.value!
            .substring(_groupImageURL.value!.indexOf('/groups'),
                _groupImageURL.value!.indexOf('?'))
            .replaceAll('%2F', '/');
    }
  }

  Future<GroupSavingStatus> createGroup() async {
    if (_groupImageFile.value != null &&
        _groupImageURL.value != null &&
        _groupName.value != null &&
        _groupSectionName.value != null &&
        _groupSpecificArea.value != null) {
      if (!allValidPhoneNumbers()) {
        Get.snackbar('Error', 'Invalid Phone Number Entered.');
        return GroupSavingStatus.incorrectData;
      }

      String groupSectionName = Converter.asString(_groupSectionName.value!);

      List<Map<String, dynamic>> members = [];

      Alcoholic alcoholic;

      if (hasMember(0)) {
        alcoholic = Alcoholic(
          password: 'N/A',
          phoneNumber: _leaderPhoneNumber.value,
          username: _leaderUsername.value!,
          profileImageURL: trimmedImageURL(0),
          sectionName: _groupSectionName.value!,
          groupFK: _leaderPhoneNumber.value,
        );
        members.add(alcoholic.toJson());

        if (hasMember(1)) {
          alcoholic = Alcoholic(
            password: 'N/A',
            phoneNumber: _member1PhoneNumber.value,
            username: _member1Username.value!,
            profileImageURL: trimmedImageURL(1),
            sectionName: _groupSectionName.value!,
            groupFK: _leaderPhoneNumber.value,
          );
          members.add(alcoholic.toJson());

          if (hasMember(2)) {
            alcoholic = Alcoholic(
              password: 'N/A',
              phoneNumber: _member2PhoneNumber.value,
              username: _member2Username.value!,
              profileImageURL: trimmedImageURL(2),
              sectionName: _groupSectionName.value!,
              groupFK: _leaderPhoneNumber.value,
            );
            members.add(alcoholic.toJson());

            if (hasMember(3)) {
              alcoholic = Alcoholic(
                password: 'N/A',
                phoneNumber: _member3PhoneNumber.value,
                username: _member3Username.value!,
                profileImageURL: trimmedImageURL(3),
                sectionName: _groupSectionName.value!,
                groupFK: _leaderPhoneNumber.value,
              );
              members.add(alcoholic.toJson());

              if (hasMember(4)) {
                alcoholic = Alcoholic(
                  password: 'N/A',
                  phoneNumber: _member4PhoneNumber.value,
                  username: _member4Username.value!,
                  profileImageURL: trimmedImageURL(4),
                  sectionName: _groupSectionName.value!,
                  groupFK: _leaderPhoneNumber.value,
                );
                members.add(alcoholic.toJson());

                Map<String, dynamic> registrationGroup = {
                  'groupName': _groupName.value,
                  'groupImageURL': trimmedImageURL(5),
                  'groupSectionName': groupSectionName,
                  'groupSpecificArea': _groupSpecificArea.value,
                  'groupCreatorPhoneNumber': _leaderPhoneNumber.value,
                  'groupCreatorImageURL': trimmedImageURL(0),
                  'groupCreatorUsername': _leaderUsername.value,
                  'isActive': false,
                  'maxNoOfMembers': 5,
                  'groupMembers': members
                };

                // Saving With A Cloud Function.
                /*final httpCallable =
                    functions.httpsCallable('createGroup');
                await httpCallable.call(group);*/

                List<String> phoneNumbers = [];

                for (int i = 0; i < members.length; i++) {
                  phoneNumbers.add(members[i]['phoneNumber']);
                }

                Group group = Group(
                    groupName: registrationGroup['groupName'],
                    groupImageURL: registrationGroup['groupImageURL'],
                    groupSectionName: Converter.toSectionName(
                        registrationGroup['groupSectionName']),
                    groupSpecificArea: registrationGroup['groupSpecificArea'],
                    groupCreatorPhoneNumber:
                        registrationGroup['groupCreatorPhoneNumber'],
                    groupCreatorImageURL:
                        registrationGroup['groupCreatorImageURL'],
                    groupCreatorUsername:
                        registrationGroup['groupCreatorUsername'],
                    groupMembers: phoneNumbers,
                    maxNoOfMembers: registrationGroup['maxNoOfMembers']);

                await firestore
                    .collection('groups')
                    .doc(group.creatorPhoneNumber)
                    .set(group.toJson());

                for (int alcoholicIndex = 0;
                    alcoholicIndex < members.length;
                    alcoholicIndex++) {
                  Alcoholic alcoholic =
                      Alcoholic.fromJson(members[alcoholicIndex]);
                  await firestore
                      .collection('alcoholics')
                      .doc(alcoholic.phoneNumber)
                      .set(alcoholic.toJson());
                }

                if (hasMember(0)) {
                  await uploadResource(leaderProfileImageFile!,
                      'group_members/$_leaderPhoneNumber/$_leaderPhoneNumber');
                }

                if (hasMember(1)) {
                  await uploadResource(member1ProfileImageFile!,
                      'group_members/$_leaderPhoneNumber/$_member1PhoneNumber');
                }

                if (hasMember(2)) {
                  await uploadResource(member2ProfileImageFile!,
                      'group_members/$_leaderPhoneNumber/$_member2PhoneNumber');
                }

                if (hasMember(3)) {
                  await uploadResource(member3ProfileImageFile!,
                      'group_members/$_leaderPhoneNumber/$_member3PhoneNumber');
                }

                if (hasMember(4)) {
                  await uploadResource(member4ProfileImageFile!,
                      'group_members/$_leaderPhoneNumber/$_member4PhoneNumber');
                }
                Get.snackbar('Group Status', 'Saved Group Successfully .');

                return GroupSavingStatus.saved;
              } else {
                Get.snackbar('Error', 'Forth Member Info Is Missing .');
                return GroupSavingStatus.incompleteData;
              }
            } else {
              Get.snackbar('Error', 'Third Member Info Is Missing .');
              return GroupSavingStatus.incompleteData;
            }
          } else {
            Get.snackbar('Error', 'Second Member Info Is Missing .');
            return GroupSavingStatus.incompleteData;
          }
        } else {
          Get.snackbar('Error', 'First Member Info Is Missing .');
          return GroupSavingStatus.incompleteData;
        }
      } else {
        Get.snackbar('Error', 'Leader Info Is Missing .');
        return GroupSavingStatus.incompleteData;
      }
    } else {
      Get.snackbar('Error', 'Group Info Is Missing .');
      return GroupSavingStatus.incompleteData;
    }
  }

  Stream<List<Group>> readAllGroups() {
    Stream<List<Group>> stream = firestore
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Group group = Group.fromJson(doc.data());
              return group;
            }).toList());

    return stream;
  }

  Stream<List<Group>> readGroups(SectionName sectionName) {
    Stream<List<Group>> stream = firestore
        .collection('groups')
        .where("groupSectionName", isEqualTo: Converter.asString(sectionName))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Group group = Group.fromJson(doc.data());
              return group;
            }).toList());

    return stream;
  }

  Future<List<Group>> readFutureAllGroups() async {
    return firestore.collection('groups').snapshots().map(((doc) {
      Group group = Group.fromJson(doc);
      return group;
    })).toList();
  }

  GroupUpdatingStatus switchGroup(String to) {
    GroupUpdatingStatus groupUpdatingStatus = GroupUpdatingStatus.loginRequired;

    // The user is currently logged in.
    if (auth.currentUser != null) {
      String phoneNumber = auth.currentUser!.phoneNumber!;
      firestore
          .collection('alcoholics')
          .doc(phoneNumber)
          .snapshots()
          .map((alcoholicSnapshot) {
        // The currently logged in user is an alcoholic.
        if (alcoholicSnapshot.exists) {
          Alcoholic alcoholic = Alcoholic.fromJson(alcoholicSnapshot.data());

          // Currently logged in user belong to some group.
          if (alcoholic.groupFK != null) {
            firestore
                .collection('groups')
                .doc(alcoholic.groupFK!)
                .snapshots()
                .map((fromGroupSnapshot) {
              // The group from which the current user belongs to still exists.
              if (fromGroupSnapshot.exists) {
                Group fromGroup = Group.fromJson(fromGroupSnapshot.data());

                // The current user is not a create of the from group.
                if (fromGroup.groupCreatorPhoneNumber.compareTo(phoneNumber) !=
                    0) {
                  firestore
                      .collection('groups')
                      .doc(to)
                      .snapshots()
                      .map((toGroupSnapshot) {
                    // The to group will always exists.
                    Group toGroup = Group.fromJson(toGroupSnapshot.data());

                    // The destination group is still accepting new members.
                    if (toGroup.groupMembers.length < toGroup.maxNoOfMembers) {
                      /* Perform a transaction [remove member from 'from' group, 
                      add member to 'to' group, update member groupFK].*/
                      firestore.runTransaction((transaction) async {
                        if (fromGroup.removeMember(alcoholic.phoneNumber) &&
                            toGroup.addMember(alcoholic.phoneNumber)) {
                          transaction.update(fromGroupSnapshot.reference,
                              {'groupMembers': fromGroup.groupMembers});
                          transaction.update(toGroupSnapshot.reference,
                              {'groupMembers': toGroup.groupMembers});
                          transaction.update(alcoholicSnapshot.reference,
                              {'groupFK': toGroup.groupCreatorPhoneNumber});
                          groupUpdatingStatus = GroupUpdatingStatus.updated;
                        } else {
                          groupUpdatingStatus =
                              GroupUpdatingStatus.unathourized;
                        }
                      });
                    }
                    // The destination group is filled.
                    else {
                      groupUpdatingStatus =
                          GroupUpdatingStatus.destinationGroupFilled;
                    }
                  });
                }
                // The current user is the creator of the from group.
                else {
                  groupUpdatingStatus =
                      GroupUpdatingStatus.groupDeletionRequired;
                }
              }
              // The group from which the current user belongs to no longer exists.
              else {}
            });
          }

          // Currently logged in user do not belong to some group.
          else {
            firestore
                .collection('groups')
                .doc(to)
                .snapshots()
                .map((toGroupSnapshot) {
              // The to group will always exists.
              Group toGroup = Group.fromJson(toGroupSnapshot.data());

              // The destination group is still accepting new members.
              if (toGroup.groupMembers.length < toGroup.maxNoOfMembers) {
                /* Perform a transaction [ add member to 'to' group, 
                update member groupFK].*/
                firestore.runTransaction((transaction) async {
                  if (toGroup.addMember(alcoholic.phoneNumber)) {
                    transaction.update(toGroupSnapshot.reference,
                        {'groupMembers': toGroup.groupMembers});
                    transaction.update(alcoholicSnapshot.reference,
                        {'groupFK': toGroup.groupCreatorPhoneNumber});
                    groupUpdatingStatus = GroupUpdatingStatus.updated;
                  }
                  // The destination group is filled.
                  else {
                    groupUpdatingStatus =
                        GroupUpdatingStatus.destinationGroupFilled;
                  }
                });
              }
              // The destination group is filled.
              else {
                groupUpdatingStatus =
                    GroupUpdatingStatus.destinationGroupFilled;
              }
            });
          }
        }
        // // The currently logged in user is an admin or any other type of user.
        else {
          groupUpdatingStatus = GroupUpdatingStatus.unathourized;
        }
      });
    }

    return groupUpdatingStatus;
  }
}
