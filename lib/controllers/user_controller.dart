import 'dart:io';
import 'dart:developer' as debug;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Utilities/converter.dart';
import '../models/Utilities/section_name.dart';
import '../models/users/alcoholic.dart';
import '../models/users/group.dart';
import 'share_dao_functions.dart';

enum GroupSavingStatus {
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

// Branch : users_data_access
class UserController extends GetxController {
  static UserController instance = Get.find();

  late Rx<File?> pickedProfileImageFile;
  File? get alcoholicProfileImageFile => pickedProfileImageFile.value;

  void chooseAlcoholicProfileImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar('Image Status', 'Image File Successfully Picked.');
    }

    // Share the chosen image file on Getx State Management.
    pickedProfileImageFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void captureAlcoholicProfileImageWithCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImageFile != null) {
      Get.snackbar('Image Status', 'Image File Successfully Captured.');
    }

    // Share the chosen image file on Getx State Management.
    pickedProfileImageFile = Rx<File?>(File(pickedImageFile!.path));
  }

  // ==========================Alcoholic [Start]==========================
  void saveAlcoholic(File alcoholicProfileImage, String phoneNumber,
      SectionName sectionName, String uid, String username) async {
    // Step 1 - create user in the firebase authentication. [Performed On The Screen Calling This Method]
    // Step 2 - save user image in firebase storage.
    // Step 3 - save user data in cloud firestore database.
    try {
      // 'gs://alcoholic-expressions.appspot.com/alcoholics/+27625446322.jpg'
      // 1. Create download URL & save alcoholic image in firebase storage.
      String alcoholicImageURL = await uploadResource(alcoholicProfileImage,
          '/alcoholics/$phoneNumber/profile_images/$phoneNumber');

      Alcoholic alcoholic = Alcoholic(
          phoneNumber: phoneNumber,
          profileImageURL: alcoholicImageURL,
          username: username,
          sectionName: sectionName);

      // 3. Save alcoholic object
      await FirebaseFirestore.instance
          .collection('alcoholics')
          .doc(phoneNumber)
          .set(alcoholic.toJson());
      showProgressBar = false;
    } catch (error) {
      Get.snackbar("Saving Error", "Alcoholic Couldn'\t Be Saved.");
      debug.log(error.toString());
      showProgressBar = false;
    }
  }

  // ==========================Alcoholic [End]==========================

  // ==========================Group [Start]==========================
  // groups_crud -> create_group
  GroupSavingStatus saveGroup(
    File groupImage,
    String groupName,
    String groupSpecificArea,
  ) {
    GroupSavingStatus groupSavingStatus = GroupSavingStatus.loginRequired;

    if (FirebaseAuth.instance.currentUser != null) {
      String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;

      FirebaseFirestore.instance
          .collection('alcoholics')
          .doc(phoneNumber)
          .snapshots()
          .map((alcoholicSnapshot) {
        if (alcoholicSnapshot.exists) {
          Alcoholic alcoholic = Alcoholic.fromJson(alcoholicSnapshot.data());

          FirebaseFirestore.instance
              .collection('groups')
              .doc(alcoholic.phoneNumber)
              .snapshots()
              .map((groupSnapshot) async {
            if (!groupSnapshot.exists) {
              try {
                // 'gs://alcoholic-expressions.appspot.com/groups_specific_locations/+27625446322.jpg'
                // 1. Create download URL & save group image in firebase storage.
                String groupImageURL = await uploadResource(groupImage,
                    '/groups_specific_locations/${alcoholic.phoneNumber}');

                Group group = Group(
                    groupName: groupName,
                    groupImageURL: groupImageURL,
                    groupSectionName: alcoholic.sectionName,
                    groupSpecificArea: groupSpecificArea,
                    groupCreatorPhoneNumber: alcoholic.phoneNumber,
                    groupCreatorImageURL: alcoholic.profileImageURL,
                    groupCreatorUsername: alcoholic.username,
                    groupMembers: [alcoholic.phoneNumber],
                    maxNoOfMembers: 5);

                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(group.groupCreatorPhoneNumber)
                    .set(group.toJson());
                showProgressBar = false;
                groupSavingStatus = GroupSavingStatus.saved;
              } catch (error) {
                Get.snackbar("Saving Error", "Group Couldn'\t Be Saved.");
                debug.log(error.toString());
                showProgressBar = false;
              }
            } else {
              groupSavingStatus = GroupSavingStatus.alreadyCreatedGroup;
            }
          });
        }
      });
    }

    return groupSavingStatus;
  }

  // groups_crud -> view_groups
  Stream<List<Group>> readAllGroups() {
    Stream<List<Group>> stream = FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Group group = Group.fromJson(doc.data());
              return group;
            }).toList());

    return stream;
  }

  // groups_crud -> view_groups
  Stream<List<Group>> readGroups(SectionName sectionName) {
    Stream<List<Group>> stream = FirebaseFirestore.instance
        .collection('groups')
        .where("groupSectionName", isEqualTo: Converter.asString(sectionName))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Group group = Group.fromJson(doc.data());
              return group;
            }).toList());

    return stream;
  }

  // To Remove - Branches groups_crud -> view_groups
  Future<List<Group>> readFutureAllGroups() async {
    return FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map(((doc) {
      Group group = Group.fromJson(doc);
      return group;
    })).toList();
  }

  // groups_crud -> update_group
  GroupUpdatingStatus switchGroup(String to) {
    GroupUpdatingStatus groupUpdatingStatus = GroupUpdatingStatus.loginRequired;

    // The user is currently logged in.
    if (FirebaseAuth.instance.currentUser != null) {
      String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
      FirebaseFirestore.instance
          .collection('alcoholics')
          .doc(phoneNumber)
          .snapshots()
          .map((alcoholicSnapshot) {
        // The currently logged in user is an alcoholic.
        if (alcoholicSnapshot.exists) {
          Alcoholic alcoholic = Alcoholic.fromJson(alcoholicSnapshot.data());

          // Currently logged in user belong to some group.
          if (alcoholic.groupFK != null) {
            FirebaseFirestore.instance
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
                  FirebaseFirestore.instance
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
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
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
            FirebaseFirestore.instance
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
                FirebaseFirestore.instance.runTransaction((transaction) async {
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

  /*======================Groups[End]======================== */

}
