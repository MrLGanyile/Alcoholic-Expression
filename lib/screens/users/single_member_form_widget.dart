import 'package:alco/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/share_dao_functions.dart';
import '../../controllers/user_controller.dart';
import 'single_member_text_field.dart';

import 'dart:developer' as debug;

// Branch : group_resources_crud ->  create_group_resources_front_end
class SingleMemberFormWidget extends StatefulWidget {
  TextEditingController userNameController;
  TextEditingController phoneNumberController;
  int memberIndex;

  SingleMemberFormWidget({
    required this.userNameController,
    required this.phoneNumberController,
    required this.memberIndex,
  });

  @override
  State<StatefulWidget> createState() => SingleMemberFormWidgetState();
}

class SingleMemberFormWidgetState extends State<SingleMemberFormWidget> {
  UserController userController = UserController.instance;

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
            controller: widget.userNameController,
            labelText: labelText1,
            memberIndex: widget.memberIndex,
          ),
          const SizedBox(height: 5),
          SingleMemberTextField(
            controller: widget.phoneNumberController,
            labelText: labelText2,
            memberIndex: widget.memberIndex,
            isForUserName: false,
          ),
          const SizedBox(height: 5),
          pickedMemberImage(),
          const SizedBox(height: 5),
          singleUserImagePicker(),
        ]),
      );

  Widget singleUserImagePicker() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Upload Icon
          Expanded(
            child: IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.upload, color: MyApplication.logoColor1),
                onPressed: () async {
                  userController.chooseMemberProfileImageFromGallery(
                      widget.memberIndex,
                      widget.phoneNumberController.text,
                      widget.userNameController.text);

                  debug.log(
                      'Member Index ${widget.memberIndex} Phone No ${widget.phoneNumberController.text}');
                }),
          ),
          // 'Or' Icons Seperator
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
          // Camera Icon
          Expanded(
            child: IconButton(
              color: Colors.white,
              iconSize: MediaQuery.of(context).size.width * 0.15,
              icon: Icon(Icons.camera_alt, color: MyApplication.logoColor1),
              onPressed: () async {
                userController.captureMemberProfileImageFromCamera(
                    widget.memberIndex,
                    widget.phoneNumberController.text,
                    widget.userNameController.text);

                debug.log(
                    'Member Index ${widget.memberIndex} Phone No ${widget.phoneNumberController.text}');
              },
            ),
          ),
        ],
      );

  Widget pickedMemberImage() {
    switch (widget.memberIndex) {
      case 1:
        return GetBuilder<UserController>(builder: (_) {
          return userController.member1ImageURL!.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                // Get.find<UserController>().member1ImageURL!
                                NetworkImage(userController.member1ImageURL!))),
                  ),
                );
        });
      case 2:
        return GetBuilder<UserController>(builder: (_) {
          return userController.member2ImageURL!.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(userController.member2ImageURL!))),
                  ),
                );
        });
      case 3:
        return GetBuilder<UserController>(builder: (_) {
          return userController.member3ImageURL!.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(userController.member3ImageURL!))),
                  ),
                );
        });
      case 4:
        return GetBuilder<UserController>(builder: (_) {
          return userController.member4ImageURL!.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(userController.member4ImageURL!))),
                  ),
                );
        });
      default:
        return GetBuilder<UserController>(builder: (_) {
          return userController.leaderImageURL!.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(userController.leaderImageURL!))),
                  ),
                );
        });
    }
  }
}
