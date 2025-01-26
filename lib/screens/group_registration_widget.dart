import 'dart:io';

import 'package:alco/screens/single_member_form_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/location_controller.dart';
import '../controllers/share_dao_functions.dart';
import '../controllers/user_controller.dart';
import '../main.dart';
import '../models/locations/converter.dart';
import '../models/locations/supported_area.dart';
import '../models/users/alcoholic.dart';
import 'page_navigation.dart';
import 'dart:developer' as debug;
import 'dart:math';

import 'verification_screen.dart';

// Branch : group_resources_crud ->  create_group_resources_front_end
class GroupRegistrationWidget extends StatefulWidget {
  String adminPhoneNumber;

  GroupRegistrationWidget({required this.adminPhoneNumber});

  @override
  State<StatefulWidget> createState() => GroupRegistrationWidgetState();
}

class GroupRegistrationWidgetState extends State<GroupRegistrationWidget> {
  TextEditingController groupNameEditingController = TextEditingController();
  TextEditingController groupSpecificAreaEditingController =
      TextEditingController();
  TextEditingController groupSectionNameEditingController =
      TextEditingController();

  String? groupName;
  String? groupImageURL;
  String? groupSpecificArea;
  String? groupSectionName;

  TextEditingController leaderUsernameEditingController =
      TextEditingController();
  TextEditingController leaderPhoneNumberEditingController =
      TextEditingController();
  bool hasLeader = false;
  String? leaderImageURL;
  String? leaderPhoneNumber;
  String? leaderUsername;

  TextEditingController username1EditingController = TextEditingController();
  TextEditingController phoneNumber1EditingController = TextEditingController();
  bool hasUser1 = false;
  String? user1ImageURL;
  String? user1PhoneNumber;
  String? user1Username;

  TextEditingController username2EditingController = TextEditingController();
  TextEditingController phoneNumber2EditingController = TextEditingController();
  bool hasUser2 = false;
  String? user2ImageURL;
  String? user2PhoneNumber;
  String? user2Username;

  TextEditingController username3EditingController = TextEditingController();
  TextEditingController phoneNumber3EditingController = TextEditingController();
  bool hasUser3 = false;
  String? user3ImageURL;
  String? user3PhoneNumber;
  String? user3Username;

  TextEditingController username4EditingController = TextEditingController();
  TextEditingController phoneNumber4EditingController = TextEditingController();
  bool hasUser4 = false;
  String? user4ImageURL;
  String? user4PhoneNumber;
  String? user4Username;

  UserController userController = UserController.instance;

  late Stream<List<SupportedArea>> supportedAreasStream;
  late List<String> items;
  LocationController locationController = LocationController.locationController;
  late DropdownButton2<String> dropDowButton;
  String? selectedValue;

  GroupRegistrationWidgetState();

  @override
  void initState() {
    super.initState();

    supportedAreasStream = locationController.readAllSupportedAreas();
  }

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
              Navigator.pop(context);
            }),
          ),
          elevation: 0,
        ),
        body: Container(
          color: Colors.black,
          child: buildRecruit(),
        ),
      );

  bool isValidInput() {
    bool hasGroup = groupName != null &&
        groupSectionName != null &&
        groupSpecificArea != null &&
        groupImageURL != null;

    if (hasGroup == false) {
      return false;
    }

    if (hasUser(1) &&
        containsNumbersOnly(user1PhoneNumber!) &&
        user1Username != null) {
      hasUser1 = true;
      return true;
    }

    if (hasUser(1) &&
        containsNumbersOnly(user1PhoneNumber!) &&
        user1Username != null &&
        hasUser(2) &&
        containsNumbersOnly(user2PhoneNumber!) &&
        user2Username != null) {
      hasUser2 = true;
    }

    if (hasUser(1) &&
        containsNumbersOnly(user1PhoneNumber!) &&
        user1Username != null &&
        hasUser(2) &&
        containsNumbersOnly(user2PhoneNumber!) &&
        user2Username != null &&
        hasUser(3) &&
        containsNumbersOnly(user3PhoneNumber!) &&
        user3Username != null) {
      hasUser3 = true;
    }

    if (hasUser(1) &&
        containsNumbersOnly(user1PhoneNumber!) &&
        user1Username != null &&
        hasUser(2) &&
        containsNumbersOnly(user2PhoneNumber!) &&
        user2Username != null &&
        hasUser(3) &&
        containsNumbersOnly(user3PhoneNumber!) &&
        user3Username != null &&
        hasUser(4) &&
        containsNumbersOnly(user4PhoneNumber!) &&
        user4Username != null) {
      hasUser4 = true;
    }

    if (hasUser(1) &&
        containsNumbersOnly(user1PhoneNumber!) &&
        user1Username != null &&
        hasUser(2) &&
        containsNumbersOnly(user2PhoneNumber!) &&
        user2Username != null &&
        hasUser(3) &&
        containsNumbersOnly(user3PhoneNumber!) &&
        user3Username != null &&
        hasUser(4) &&
        containsNumbersOnly(user4PhoneNumber!) &&
        user4Username != null &&
        hasUser(0) &&
        containsNumbersOnly(leaderPhoneNumber!) &&
        leaderUsername != null) {
      hasLeader = true;
    }

    return hasUser1 || hasUser2 || hasUser3 || hasUser4 || hasLeader;
  }

  bool hasUser(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return user1ImageURL != null &&
            user1PhoneNumber != null &&
            user1Username != null;
      case 2:
        return user2ImageURL != null &&
            user2PhoneNumber != null &&
            user2Username != null;
      case 3:
        return user3ImageURL != null &&
            user3PhoneNumber != null &&
            user3Username != null;
      case 4:
        return user4ImageURL != null &&
            user4PhoneNumber != null &&
            user4Username != null;
      default:
        return leaderImageURL != null &&
            leaderPhoneNumber != null &&
            leaderUsername != null;
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
        return user1PhoneNumber!.length == 10 &&
            (user1PhoneNumber!.startsWith('06') ||
                user1PhoneNumber!.startsWith('07') ||
                user1PhoneNumber!.startsWith('08')) &&
            containsNumbersOnly(user1PhoneNumber!);
      case 2:
        return user2PhoneNumber!.length == 10 &&
            (user2PhoneNumber!.startsWith('06') ||
                user2PhoneNumber!.startsWith('07') ||
                user2PhoneNumber!.startsWith('08')) &&
            containsNumbersOnly(user2PhoneNumber!);
      case 3:
        return user3PhoneNumber!.length == 10 &&
            (user3PhoneNumber!.startsWith('06') ||
                user3PhoneNumber!.startsWith('07') ||
                user3PhoneNumber!.startsWith('08')) &&
            containsNumbersOnly(user3PhoneNumber!);
      case 4:
        return user4PhoneNumber!.length == 10 &&
            (user4PhoneNumber!.startsWith('06') ||
                user4PhoneNumber!.startsWith('07') ||
                user4PhoneNumber!.startsWith('08')) &&
            containsNumbersOnly(user4PhoneNumber!);
      default:
        return leaderPhoneNumber!.length == 10 &&
            (leaderPhoneNumber!.startsWith('06') ||
                leaderPhoneNumber!.startsWith('07') ||
                leaderPhoneNumber!.startsWith('08')) &&
            containsNumbersOnly(leaderPhoneNumber!);
    }
  }

  void updateGroupName(String groupName) {
    setState(() {
      this.groupName = groupName;
    });
  }

  void updateGroupImageURL(String groupImageURL) {
    setState(() {
      this.groupImageURL = groupImageURL;
    });
  }

  void updateGroupSpecificArea(String groupSpecificArea) {
    setState(() {
      this.groupSpecificArea = groupSpecificArea;
    });
  }

  void updatePhoneNumber(int memberIndex, String phoneNumber) {
    switch (memberIndex) {
      case 1:
        user1PhoneNumber = phoneNumber;
        break;
      case 2:
        user2PhoneNumber = phoneNumber;
        break;
      case 3:
        user3PhoneNumber = phoneNumber;
        break;
      case 4:
        user4PhoneNumber = phoneNumber;
        break;
      default:
        leaderPhoneNumber = phoneNumber;
    }
  }

  void updateProfileImageURL(int memberIndex, String profileImageURL) {
    switch (memberIndex) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
    }
  }

  void updateUsername(int memberIndex, String username) {
    switch (memberIndex) {
      case 1:
        user1Username = username;
        break;
      case 2:
        user2Username = username;
        break;
      case 3:
        user3Username = username;
        break;
      case 4:
        user4Username = username;
        break;
      default:
        leaderUsername = username;
    }
  }

  Widget buildRecruit() {
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
            controller1: leaderUsernameEditingController,
            controller2: leaderPhoneNumberEditingController,
            memberIndex: 0,
            onPhoneNumberChanged: updatePhoneNumber,
            onProfileImageURLChanged: updateProfileImageURL,
            onUsernameChanged: updateUsername,
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
                return pickAreaName();
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
          groupPicking(),

          const SizedBox(
            height: 10,
          ),

          SingleMemberFormWidget(
            controller1: username1EditingController,
            controller2: phoneNumber1EditingController,
            memberIndex: 1,
            onPhoneNumberChanged: updatePhoneNumber,
            onProfileImageURLChanged: updateProfileImageURL,
            onUsernameChanged: updateUsername,
          ),
          SingleMemberFormWidget(
            controller1: username2EditingController,
            controller2: phoneNumber2EditingController,
            memberIndex: 2,
            onPhoneNumberChanged: updatePhoneNumber,
            onProfileImageURLChanged: updateProfileImageURL,
            onUsernameChanged: updateUsername,
          ),
          SingleMemberFormWidget(
            controller1: username3EditingController,
            controller2: phoneNumber3EditingController,
            memberIndex: 3,
            onPhoneNumberChanged: updatePhoneNumber,
            onProfileImageURLChanged: updateProfileImageURL,
            onUsernameChanged: updateUsername,
          ),
          SingleMemberFormWidget(
            controller1: username4EditingController,
            controller2: phoneNumber4EditingController,
            memberIndex: 4,
            onPhoneNumberChanged: updatePhoneNumber,
            onProfileImageURLChanged: updateProfileImageURL,
            onUsernameChanged: updateUsername,
          ),
          signInButton(),
        ]),
      ),
    );
  }

  AspectRatio retrieveGroupImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: groupImageURL != null
          ? Container(
              //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(groupImageURL!),
                ),
              ),
            )
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: MyApplication.logoColor1,
              ),
              child: const Text(
                'Group Image Area',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
    );
  }

  Widget groupPicking() {
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
                  userController.captureGroupProfileImageWithCamera();

                  if (userController.groupImageFile != null &&
                      leaderPhoneNumber != null) {
                    groupImageURL = await uploadResource(
                        userController.groupImageFile!,
                        '/group_specific_locations/$leaderPhoneNumber');

                    updateGroupImageURL(groupImageURL!);
                  }
                }),
            IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.upload, color: MyApplication.logoColor1),
                onPressed: () async {
                  userController.chooseGroupImageFromGallery();

                  if (userController.groupImageFile != null &&
                      leaderPhoneNumber != null) {
                    groupImageURL = await uploadResource(
                        userController.groupImageFile!,
                        '/group_specific_locations/$leaderPhoneNumber');
                    updateGroupImageURL(groupImageURL!);
                  }
                }),
          ]),
        ),
      ],
    );
  }

  Widget signInButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            color: MyApplication.logoColor1,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            )),
        child: InkWell(
          onTap: () async {
            await userController.createGroup(
              userController.groupImageFile!,
              'Goal Creators',
              'Mpompini',
              Converter.toSectionName(dropDowButton.value!),
              userController.leaderProfileImageFile!,
              leaderPhoneNumber!,
              leaderUsername!,
              [
                leaderPhoneNumber!,
                user1PhoneNumber!,
                user2PhoneNumber!
              ], // Phone Numbers
              [leaderUsername!, user1Username!, user2Username!], // Usernames
              [
                userController.leaderProfileImageFile!,
                userController.member1ProfileImageFile!,
                userController.member2ProfileImageFile!,
              ], // Profile Images
            );
            debug.log('Done Saving Group.');
            /*GroupSavingStatus groupSavingStatus = userController.saveGroup(
              File(
                  'C:\\Users\\Lwandile-Ganyile\\Documents\\Lwandile Ganyile\\Alcoholic-Expression\\Storage Duplicate\\groups_specific_locations\\+27657635413.jpg'),
              'Goal Creators',
              'Mpompini',
              Converter.toSectionName(dropDowButton.value!),
            ); */

            // Create Alcoholic Now
            if (isValidInput()) {
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
                        user1PhoneNumber!,
                        Converter.toSectionName(dropDowButton.value!),
                        user1PhoneNumber!,
                        user1Username!);
                  }

                  // Save Member 2
                  if (hasUser2) {
                    userController.saveAlcoholic(
                        userController.member2ProfileImageFile!,
                        user1PhoneNumber!,
                        Converter.toSectionName(dropDowButton.value!),
                        user2PhoneNumber!,
                        user2Username!);
                  }

                  // Save Member 3
                  if (hasUser3) {
                    userController.saveAlcoholic(
                        userController.member3ProfileImageFile!,
                        user1PhoneNumber!,
                        Converter.toSectionName(dropDowButton.value!),
                        user3PhoneNumber!,
                        user3Username!);
                  }

                  // Save Member 4
                  if (hasUser4) {
                    userController.saveAlcoholic(
                        userController.member4ProfileImageFile!,
                        user4PhoneNumber!,
                        Converter.toSectionName(dropDowButton.value!),
                        user4PhoneNumber!,
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

  Widget pickAreaName() {
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
      value: selectedValue,
      onChanged: (String? value) {
        setState(() {
          selectedValue = value;
          groupSectionName = dropDowButton.value;
        });
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
        onChanged: forSpecificArea ? updateGroupSpecificArea : updateGroupName,
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
