import 'package:alco/main.dart';
import 'package:flutter/material.dart';

import '../controllers/share_dao_functions.dart';
import '../controllers/user_controller.dart';
import 'single_member_text_field.dart';

typedef OnProfileImageURLChanged = Function(int, String);

class SingleMemberFormWidget extends StatefulWidget {
  TextEditingController controller1;
  TextEditingController controller2;
  int memberIndex;

  OnPhoneNumberChanged onPhoneNumberChanged;
  OnProfileImageURLChanged onProfileImageURLChanged;
  OnUsernameChanged onUsernameChanged;

  SingleMemberFormWidget({
    required this.controller1,
    required this.controller2,
    required this.memberIndex,
    required this.onPhoneNumberChanged,
    required this.onProfileImageURLChanged,
    required this.onUsernameChanged,
  });

  @override
  State<StatefulWidget> createState() => SingleMemberFormWidgetState();
}

class SingleMemberFormWidgetState extends State<SingleMemberFormWidget> {
  UserController userController = UserController.instance;

  String? profileImageURL;
  String? phoneNumber;

  String labelText1 = 'Leader Username';
  String labelText2 = 'Leader Phone Number';

  void setLabels() {
    if (widget.memberIndex > 0) {
      labelText1 = 'Member ${widget.memberIndex} Username';
      labelText2 = 'Member ${widget.memberIndex} Phone Number';
    }
  }

  @override
  void initState() {
    super.initState();
    setLabels();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(children: [
          SingleMemberTextField(
            controller: widget.controller1,
            labelText: labelText1,
            onUsernameChanged: widget.onUsernameChanged,
            memberIndex: widget.memberIndex,
          ),
          const SizedBox(height: 5),
          SingleMemberTextField(
            controller: widget.controller2,
            labelText: labelText2,
            onPhoneNumberChanged: widget.onPhoneNumberChanged,
            memberIndex: widget.memberIndex,
            isForUserName: false,
          ),
          const SizedBox(height: 10),
          singleUserImagePicker(),
        ]),
      );

  Widget singleUserImagePicker() => profileImageURL != null
      ? Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(
                profileImageURL!,
              ),
              fit: BoxFit.cover,
            ),
          ),
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                  color: Colors.white,
                  iconSize: MediaQuery.of(context).size.width * 0.15,
                  icon: Icon(Icons.upload, color: MyApplication.logoColor1),
                  onPressed: () {}),
            ),
            Expanded(
                child: Center(
              child: Text(
                'Or',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: MyApplication.attractiveColor1,
                ),
              ),
            )),
            Expanded(
              child: IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.camera_alt, color: MyApplication.logoColor1),
                onPressed: () async {
                  userController
                      .chooseMemberProfileImageFromGallery(widget.memberIndex);

                  switch (widget.memberIndex) {
                    case 1:
                      // We might save a profile image only to find that the group registration won't succeed.
                      if (userController.member1ProfileImageFile != null) {
                        widget.onProfileImageURLChanged(
                            widget.memberIndex,
                            await uploadResource(
                                userController.member1ProfileImageFile!,
                                '/alcoholics/$phoneNumber/profile_images/$phoneNumber'));
                      }
                      break;
                    case 2:
                      // We might save a profile image only to find that the group registration won't succeed.
                      if (userController.member2ProfileImageFile != null) {
                        widget.onProfileImageURLChanged(
                            widget.memberIndex,
                            await uploadResource(
                                userController.member2ProfileImageFile!,
                                '/alcoholics/$phoneNumber/profile_images/$phoneNumber'));
                      }
                      break;
                    case 3:
                      // We might save a profile image only to find that the group registration won't succeed.
                      if (userController.member3ProfileImageFile != null) {
                        widget.onProfileImageURLChanged(
                            widget.memberIndex,
                            await uploadResource(
                                userController.member3ProfileImageFile!,
                                '/alcoholics/$phoneNumber/profile_images/$phoneNumber'));
                      }
                      break;
                    case 4:
                      // We might save a profile image only to find that the group registration won't succeed.
                      if (userController.member4ProfileImageFile != null) {
                        widget.onProfileImageURLChanged(
                            widget.memberIndex,
                            await uploadResource(
                                userController.member4ProfileImageFile!,
                                '/alcoholics/$phoneNumber/profile_images/$phoneNumber'));
                      }
                      break;
                    default:
                      // We might save a profile image only to find that the group registration won't succeed.
                      if (userController.leaderProfileImageFile != null) {
                        widget.onProfileImageURLChanged(
                            widget.memberIndex,
                            await uploadResource(
                                userController.leaderProfileImageFile!,
                                '/alcoholics/$phoneNumber/profile_images/$phoneNumber'));
                      }
                  }
                },
              ),
            ),
          ],
        );
}
