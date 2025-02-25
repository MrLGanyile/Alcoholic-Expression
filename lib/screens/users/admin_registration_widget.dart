import '../../controllers/share_dao_functions.dart';
import '/controllers/admin_controller.dart';
import '/models/locations/converter.dart';
import 'package:get/get.dart';

import '/screens/utils/page_navigation.dart';
import '/screens/users/verification_screen.dart';

import '/models/locations/supported_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_container/easy_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/group_controller.dart';
import '../../main.dart';

import 'dart:developer' as debug;

import 'login_widget.dart';

class AdminRegistrationWidget extends StatelessWidget {
  AdminRegistrationWidget({
    Key? key,
  }) : super(key: key);

  GroupController groupController = GroupController.instance;
  AdminController adminController = AdminController.instance;
  LocationController locationController = LocationController.locationController;

  late Stream<List<SupportedArea>> supportedAreasStream =
      locationController.readAllSupportedAreas();
  late List<String> items;

  List<String> gender = ['Female', 'Male'];
  String currentGender = 'Female';

  Color textColor = Colors.green;
  late DropdownButton2<String> dropDowButton;

  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  // Include radio buttons for isFemale
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: MyApplication.backArrowFontSize,
            color: MyApplication.backArrowColor,
            onPressed: (() {
              Get.back();
            }),
          ),
          title: Text(
            'Registration',
            style: TextStyle(
              fontSize: MyApplication.backArrowTitleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: MyApplication.backArrowTitleColor,
          elevation: 0,
        ),
        backgroundColor: MyApplication.scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(children: [
              CircleAvatar(
                backgroundImage: const AssetImage('assets/logo.png'),
                radius: MediaQuery.of(context).size.width * 0.15,
              ),

              const SizedBox(
                height: 10,
              ),

              // Admin Phone Number.
              EasyContainer(
                elevation: 0,
                height: 70,
                borderRadius: 6,
                color: MyApplication.scaffoldColor,
                showBorder: true,
                borderColor: MyApplication.logoColor2,
                child: IntlPhoneField(
                  controller: phoneNumberEditingController,
                  cursorColor: MyApplication.logoColor1,
                  autofocus: false,
                  showDropdownIcon: false,
                  //invalidNumberMessage: '[Invalid Phone Number!]',

                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: MyApplication.logoColor1,
                  ),
                  dropdownTextStyle:
                      TextStyle(fontSize: 16, color: MyApplication.logoColor1),
                  //onChanged: (phone) =>phoneNumberEditingController.text = phone.completeNumber,
                  initialCountryCode: 'ZA',
                  flagsButtonPadding: const EdgeInsets.only(right: 10),
                  keyboardType: TextInputType.phone,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Admin Area Name
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
                    return pickAreaName(context);
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
                height: 5,
              ),

              // Femal Or Male
              GetBuilder<AdminController>(builder: (_) {
                return Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: Text(
                            gender[0],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyApplication.logoColor1),
                          ),
                          value: gender[0],
                          groupValue: adminController.newAdminIsFemale
                              ? gender[0]
                              : gender[1],
                          onChanged: (newValue) {
                            if (newValue == 'Female') {
                              adminController.setNewAdminIsFemale(true);
                            } else {
                              adminController.setNewAdminIsFemale(false);
                            }
                          }),
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: Text(
                            gender[1],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyApplication.logoColor1),
                          ),
                          value: gender[1],
                          groupValue: adminController.newAdminIsFemale
                              ? gender[0]
                              : gender[1],
                          onChanged: (newValue) {
                            if (newValue == 'Female') {
                              adminController.setNewAdminIsFemale(true);
                            } else {
                              adminController.setNewAdminIsFemale(false);
                            }
                          }),
                    ),
                  ],
                );
              }),

              // Admin Image
              GetBuilder<AdminController>(builder: (_) {
                return adminController.newAdminProfileImageURL.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            adminController.newAdminProfileImageURL),
                        radius: MediaQuery.of(context).size.width * 0.15,
                      )
                    : const SizedBox.shrink();
              }),

              // Image Picking Or Capturing
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Capture/Pick Admin Face',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyApplication.logoColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            //flex: 4,
                            child: IconButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.15,
                              icon: Icon(Icons.camera_alt,
                                  color: MyApplication.logoColor2),
                              onPressed: () {
                                if (isValidPhoneNumber(
                                    '0${phoneNumberEditingController.text}')) {
                                  adminController
                                      .captureAdminProfileImageWithCamera(
                                          '0${phoneNumberEditingController.text}');
                                } else {
                                  Get.snackbar('Error', 'Invalid Phone Number');
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              color: Colors.white,
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.15,
                              icon: Icon(Icons.upload,
                                  color: MyApplication.logoColor2),
                              onPressed: () {
                                if (isValidPhoneNumber(
                                    '0${phoneNumberEditingController.text}')) {
                                  adminController
                                      .chooseAdminProfileImageFromGallery(
                                    '0${phoneNumberEditingController.text}',
                                  );
                                } else {
                                  Get.snackbar('Error', 'Invalid Phone Number');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              // Password
              TextField(
                keyboardType: TextInputType.name,
                maxLength: 20,
                style: TextStyle(color: MyApplication.logoColor1),
                cursorColor: MyApplication.logoColor1,
                controller: passwordEditingController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: MyApplication.logoColor1),
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
                obscureText: true,
              ),

              const SizedBox(
                height: 5,
              ),

              showProgressBar
                  ? const SizedBox(
                      child: SimpleCircularProgressBar(
                        animationDuration: 3,
                        backColor: Colors.white,
                        progressColors: [Colors.lightBlue],
                      ),
                    )
                  : Column(
                      children: [
                        // Sign Up Admin
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: MyApplication.logoColor1,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: InkWell(
                            onTap: () async {
                              adminController.setAdminPassword(
                                  passwordEditingController.text);
                              // Create Admin Now
                              if (adminController
                                      .newAdminPhoneNumber!.isNotEmpty &&
                                  adminController.newAdminPassword.isNotEmpty &&
                                  adminController
                                      .newAdminProfileImageURL.isNotEmpty &&
                                  adminController.newAdminProfileImage !=
                                      null) {
                                debug.log(
                                    'Admin Validated From AdmiRegistrationScreen');
                                final auth = FirebaseAuth.instance;

                                await auth.verifyPhoneNumber(
                                  phoneNumber:
                                      '+27${phoneNumberEditingController.text}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    debug.log(
                                        '1. About To Signed In User From AdminRegistrationScreen...');
                                    // ANDROID ONLY!
                                    // Sign the user in (or link) with the auto-generated credential
                                    await auth.signInWithCredential(credential);

                                    debug.log(
                                        '1. Successfully Signed In User From AdminRegistrationScreen...');
                                    Future<AdminSavingStatus>
                                        adminSavingStatus =
                                        adminController.saveAdmin();

                                    adminSavingStatus.then((value) {
                                      if (value ==
                                          AdminSavingStatus.unathourized) {
                                        debug.log(
                                            'AdminSavingStatus.unathourized From AdminRegistrationScreen...');
                                      } else if (value ==
                                          AdminSavingStatus.adminAlreadyExist) {
                                        debug.log(
                                            'AdminSavingStatus.adminAlreadyExist From AdminRegistrationScreen...');
                                      } else if (value ==
                                          AdminSavingStatus.loginRequired) {
                                        debug.log(
                                            'AdminSavingStatus.loginRequired From AdminRegistrationScreen...');
                                      } else if (value ==
                                          AdminSavingStatus.incompleteData) {
                                        debug.log(
                                            'AdminSavingStatus.incompleteData From AdminRegistrationScreen...');
                                      } else {
                                        debug.log(
                                            '2. Successfully Saved User From AdminRegistrationScreen...');
                                      }
                                    });
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      debug.log(
                                          'The provided phone number is not valid.');
                                    }

                                    // Handle other errors
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    Get.to(() => VerificationScreen(
                                          phoneNumber:
                                              '+27${phoneNumberEditingController.text}',
                                          verificationId: verificationId,
                                          forAdmin: true,
                                        ));
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: MyApplication.logoColor1,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Send User To Login Screen.
                                // Send User To Login Screen.
                                logoutUser(); // Logout currently logged in user.
                                Get.to(() => LoginWidget(
                                      forAdmin: true,
                                    ));
                              },
                              child: Text(
                                " Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MyApplication.logoColor2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget pickAreaName(BuildContext context) {
    dropDowButton = DropdownButton2<String>(
      isExpanded: true,
      hint: Row(
        children: [
          Icon(
            Icons.location_city,
            size: 22,
            color: MyApplication.logoColor1,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Admin\'s Area',
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
      value: Converter.asString(adminController.newAdminSectionName),
      onChanged: (String? value) {
        adminController.setNewAdminSectionName(Converter.toSectionName(value!));
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
}
