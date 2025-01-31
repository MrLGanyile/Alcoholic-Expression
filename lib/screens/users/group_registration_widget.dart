import 'dart:io';

import 'package:alco/controllers/store_controller.dart';
import 'package:alco/screens/users/single_member_form_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/share_dao_functions.dart';
import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../../models/locations/converter.dart';
import '../../models/locations/supported_area.dart';
import '../../models/users/alcoholic.dart';
import '../utils/my_route_generator.dart';
import '../utils/page_navigation.dart';
import 'dart:developer' as debug;
import 'dart:math';

import 'groups_screen.dart';
import 'verification_screen.dart';

class GroupRegistrationWidget extends StatelessWidget {
  TextEditingController groupNameEditingController = TextEditingController();

  TextEditingController groupSpecificAreaEditingController =
      TextEditingController();

  TextEditingController leaderUsernameEditingController =
      TextEditingController();
  TextEditingController leaderPhoneNumberEditingController =
      TextEditingController();

  TextEditingController username1EditingController = TextEditingController();
  TextEditingController phoneNumber1EditingController = TextEditingController();

  TextEditingController username2EditingController = TextEditingController();
  TextEditingController phoneNumber2EditingController = TextEditingController();

  TextEditingController username3EditingController = TextEditingController();
  TextEditingController phoneNumber3EditingController = TextEditingController();

  TextEditingController username4EditingController = TextEditingController();
  TextEditingController phoneNumber4EditingController = TextEditingController();

  UserController userController = UserController.instance;
  StoreController storeController = StoreController.storeController;

  late Stream<List<SupportedArea>> supportedAreasStream =
      locationController.readAllSupportedAreas();
  late List<String> items;
  LocationController locationController = LocationController.locationController;
  late DropdownButton2<String> dropDowButton;

  GroupRegistrationWidget();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Registration',
              style: TextStyle(
                  fontSize: 14, color: MyApplication.attractiveColor1)),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 20,
            color: MyApplication.logoColor2,
            onPressed: (() {
              Get.back();
            }),
          ),
          elevation: 0,
        ),
        body: Container(
          color: Colors.black,
          child: buildRecruit(context),
        ),
      );

  bool isValidInputWithoutImages() {
    bool hasGroup = groupNameEditingController.text.isNotEmpty &&
        dropDowButton.value != null &&
        groupSpecificAreaEditingController.text.isNotEmpty;

    if (hasGroup == false) {
      return false;
    }

    if (hasUserWithoutImages(0) &&
        hasUserWithoutImages(1) &&
        hasUserWithoutImages(2) &&
        hasUserWithoutImages(3) &&
        hasUserWithoutImages(4)) {
      return true;
    }

    if (hasUserWithoutImages(0) &&
        hasUserWithoutImages(1) &&
        hasUserWithoutImages(2) &&
        hasUserWithoutImages(3)) {
      return true;
    }

    if (hasUserWithoutImages(0) &&
        hasUserWithoutImages(1) &&
        hasUserWithoutImages(2)) {
      return true;
    }

    if (hasUserWithoutImages(0) && hasUserWithoutImages(1)) {
      return true;
    }

    if (hasUserWithoutImages(0)) {
      return true;
    }

    return false;
  }

  bool hasUserWithoutImages(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return phoneNumber1EditingController.text.isNotEmpty &&
            username1EditingController.text.isNotEmpty;
      case 2:
        return phoneNumber2EditingController.text.isNotEmpty &&
            username2EditingController.text.isNotEmpty;
      case 3:
        return phoneNumber3EditingController.text.isNotEmpty &&
            username3EditingController.text.isNotEmpty;
      case 4:
        return phoneNumber4EditingController.text.isNotEmpty &&
            username4EditingController.text.isNotEmpty;
      default:
        return leaderPhoneNumberEditingController.text.isNotEmpty &&
            leaderUsernameEditingController.text.isNotEmpty;
    }
  }

  bool containsNumbersOnly(String phoneNumber) {
    for (var charIndex = 0; charIndex < phoneNumber.length; charIndex++) {
      if (!(phoneNumber[charIndex] == '0' ||
          phoneNumber[charIndex] == '1' ||
          phoneNumber[charIndex] == '2' ||
          phoneNumber[charIndex] == '3' ||
          phoneNumber[charIndex] == '4' ||
          phoneNumber[charIndex] == '5' ||
          phoneNumber[charIndex] == '6' ||
          phoneNumber[charIndex] == '7' ||
          phoneNumber[charIndex] == '8' ||
          phoneNumber[charIndex] == '9')) {
        return false;
      }
    }
    return true;
  }

  bool isValidPhoneNumber(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return username1EditingController.text.length == 10 &&
            (username1EditingController.text.startsWith('06') ||
                username1EditingController.text.startsWith('07') ||
                username1EditingController.text.startsWith('08')) &&
            containsNumbersOnly(username1EditingController.text);
      case 2:
        return username2EditingController.text.length == 10 &&
            (username2EditingController.text.startsWith('06') ||
                username2EditingController.text.startsWith('07') ||
                username2EditingController.text.startsWith('08')) &&
            containsNumbersOnly(username2EditingController.text);
      case 3:
        return username3EditingController.text.length == 10 &&
            (username3EditingController.text.startsWith('06') ||
                username3EditingController.text.startsWith('07') ||
                username3EditingController.text.startsWith('08')) &&
            containsNumbersOnly(username3EditingController.text);
      case 4:
        return username4EditingController.text.length == 10 &&
            (username4EditingController.text.startsWith('06') ||
                username4EditingController.text.startsWith('07') ||
                username4EditingController.text.startsWith('08')) &&
            containsNumbersOnly(username4EditingController.text);
      default:
        return leaderPhoneNumberEditingController.text.length == 10 &&
            (leaderPhoneNumberEditingController.text.startsWith('06') ||
                leaderPhoneNumberEditingController.text.startsWith('07') ||
                leaderPhoneNumberEditingController.text.startsWith('08')) &&
            containsNumbersOnly(leaderPhoneNumberEditingController.text);
    }
  }

  Widget buildRecruit(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          // Logo
          CircleAvatar(
            backgroundImage: const AssetImage('assets/logo.png'),
            radius: MediaQuery.of(context).size.width * 0.15,
          ),
          const SizedBox(
            height: 10,
          ),
          // Group Members
          SingleMemberFormWidget(
            userNameController: leaderUsernameEditingController,
            phoneNumberController: leaderPhoneNumberEditingController,
            memberIndex: 0,
          ),
          // Group Name
          userSpecificLocationOrGroupName(false),

          const SizedBox(
            height: 10,
          ),

          // Group Area Name
          StreamBuilder<List<SupportedArea>>(
            stream: supportedAreasStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> dbItems = [];
                for (int areaIndex = 0;
                    areaIndex < snapshot.data!.length;
                    areaIndex++) {
                  dbItems.add(snapshot.data![areaIndex].toString());
                }
                items = dbItems;
                return GetBuilder<UserController>(builder: (_) {
                  return pickAreaName(context);
                });
              } else if (snapshot.hasError) {
                debug.log(
                    "Error Fetching Supported Areas Data - ${snapshot.error}");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

          const SizedBox(
            height: 10,
          ),

          // Group Specific Area
          userSpecificLocationOrGroupName(true),

          const SizedBox(
            height: 10,
          ),

          // Group Image
          groupPicking(context),

          const SizedBox(
            height: 10,
          ),

          SingleMemberFormWidget(
            userNameController: username1EditingController,
            phoneNumberController: phoneNumber1EditingController,
            memberIndex: 1,
          ),
          SingleMemberFormWidget(
            userNameController: username2EditingController,
            phoneNumberController: phoneNumber2EditingController,
            memberIndex: 2,
          ),
          SingleMemberFormWidget(
            userNameController: username3EditingController,
            phoneNumberController: phoneNumber3EditingController,
            memberIndex: 3,
          ),
          SingleMemberFormWidget(
            userNameController: username4EditingController,
            phoneNumberController: phoneNumber4EditingController,
            memberIndex: 4,
          ),
          signInButton(context),
        ]),
      ),
    );
  }

  AspectRatio retrieveGroupImage(BuildContext context) {
    return AspectRatio(
        aspectRatio: 5 / 2,
        child: GetBuilder<UserController>(
          builder: (_) {
            return userController.groupImageURL!.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: MyApplication.logoColor1,
                    ),
                    child: const Text(
                      'Group Image Area',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                : Container(
                    //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(userController.groupImageURL!),
                      ),
                    ),
                  );
          },
        ));
  }

  Widget groupPicking(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: retrieveGroupImage(context),
        ),
        Expanded(
          flex: 1,
          child: Column(children: [
            IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.camera_alt, color: MyApplication.logoColor1),
                onPressed: () async {
                  userController.captureGroupImageWithCamera(
                      groupNameEditingController.text,
                      Converter.toSectionName(dropDowButton.value!),
                      groupSpecificAreaEditingController.text);
                }),
            IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.upload, color: MyApplication.logoColor1),
                onPressed: () async {
                  userController.chooseGroupImageFromGallery(
                      groupNameEditingController.text,
                      Converter.toSectionName(dropDowButton.value!),
                      groupSpecificAreaEditingController.text);
                }),
          ]),
        ),
      ],
    );
  }

  Widget signInButton(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            color: MyApplication.logoColor1,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            )),
        child: InkWell(
          onTap: () async {
            if (isValidInputWithoutImages()) {
              final result = await userController.createGroup();

              // Does not go to the next screen.
              if (result == GroupSavingStatus.saved) {
                Get.to(() => const GroupsScreen());
              }
            }

            // Create Alcoholic Now
            if (isValidInputWithoutImages()) {
              /*
              final auth = FirebaseAuth.instance;
              await auth.verifyPhoneNumber(
                phoneNumber: leaderPhoneNumber,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  debug.log('1. About To Signed In User...');
                  // ANDROID ONLY!
                  // Sign the user in (or link) with the auto-generated credential
                  await auth.signInWithCredential(credential);

                  debug.log('1. Successfully Signed In User...');

                  // Save Leader
                  if (hasLeader) {
                    userController.saveAlcoholic(
                        userController.leaderProfileImageFile!,
                        leaderPhoneNumber!,
                        Converter.toSectionName(dropDowButton.value!),
                        leaderPhoneNumber!,
                        leaderUsername!);
                  }

                  // Save Member 1
                  if (hasUser1) {
                    userController.saveAlcoholic(
                        userController.member1ProfileImageFile!,
                        username1EditingController.text!,
                        Converter.toSectionName(dropDowButton.value!),
                        username1EditingController.text!,
                        user1Username!);
                  }

                  // Save Member 2
                  if (hasUser2) {
                    userController.saveAlcoholic(
                        userController.member2ProfileImageFile!,
                        username1EditingController.text!,
                        Converter.toSectionName(dropDowButton.value!),
                        username2EditingController.text!,
                        user2Username!);
                  }

                  // Save Member 3
                  if (hasUser3) {
                    userController.saveAlcoholic(
                        userController.member3ProfileImageFile!,
                        username1EditingController.text!,
                        Converter.toSectionName(dropDowButton.value!),
                        username3EditingController.text!,
                        user3Username!);
                  }

                  // Save Member 4
                  if (hasUser4) {
                    userController.saveAlcoholic(
                        userController.member4ProfileImageFile!,
                        username4EditingController.text!,
                        Converter.toSectionName(dropDowButton.value!),
                        username4EditingController.text!,
                        user4Username!);
                  }

                  /*userController.saveGroup(userController.groupImageFile!,
                      groupName!, groupSpecificArea!);*/
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    debug.log('The provided phone number is not valid.');
                  }

                  // Handle other errors
                },
                codeSent: (String verificationId, int? resendToken) async {
                  String generatedPin = '';
                  for (int digitIndex = 0; digitIndex < 4; digitIndex++) {
                    generatedPin += Random().nextInt(10).toString();
                  }

                  debug.log('generated pin $generatedPin');

                  Navigator.of(context).push(CustomPageRoute(
                      child: VerificationScreen(
                    phoneNumber: '+27661813561',
                    correctPin: generatedPin,
                  )));
                  // Update the UI - wait for the user to enter the SMS code

                  // Create a PhoneAuthCredential with the code
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: '1234');

                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential);
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            
              */
            }
          },
          child: const Center(
            child: Text(
              'Create Group',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );

  Widget pickAreaName(BuildContext context) {
    dropDowButton = DropdownButton2<String>(
      isExpanded: true,
      hint: Row(
        children: [
          Icon(
            Icons.location_searching,
            size: 22,
            color: MyApplication.logoColor1,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Group Township',
              style: TextStyle(
                fontSize: 14,
                color: MyApplication.logoColor2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.logoColor1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: userController.chosenSectionName,
      onChanged: (String? value) {
        userController.setChosenSectionName(value!);
      },
      buttonStyleData: ButtonStyleData(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.90,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: MyApplication.logoColor2,
          ),
          color: MyApplication.scaffoldColor,
        ),
        elevation: 0,
      ),
      iconStyleData: IconStyleData(
        icon: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        iconSize: 14,
        iconEnabledColor: MyApplication.logoColor2,
        iconDisabledColor: Colors.grey,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black,
        ),
        offset: const Offset(10, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
    );

    return DropdownButtonHideUnderline(child: dropDowButton);
  }

  Widget userSpecificLocationOrGroupName(bool forSpecificArea) => TextField(
        style: TextStyle(color: MyApplication.logoColor1),
        cursorColor: MyApplication.logoColor1,
        controller: forSpecificArea
            ? groupSpecificAreaEditingController
            : groupNameEditingController,
        decoration: InputDecoration(
          labelText: forSpecificArea ? 'Group Specific Area' : 'Group Name',
          prefixIcon: Icon(forSpecificArea ? Icons.location_city : Icons.group,
              color: MyApplication.logoColor1),
          labelStyle: TextStyle(
            fontSize: 14,
            color: MyApplication.logoColor2,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: MyApplication.logoColor2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: MyApplication.logoColor2,
            ),
          ),
        ),
        obscureText: false,
      );
}
