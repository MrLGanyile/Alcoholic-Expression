import 'package:alco/screens/users/verification_screen.dart';
import 'package:get/get.dart';

import '../../controllers/alcoholic_controller.dart';
import '../../controllers/share_dao_functions.dart';
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
import 'dart:math';

import 'login_widget.dart';

class AlcoholicRegistrationWidget extends StatefulWidget {
  const AlcoholicRegistrationWidget({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AlcoholicRegistrationWidgetState createState() =>
      _AlcoholicRegistrationWidgetState();
}

class _AlcoholicRegistrationWidgetState
    extends State<AlcoholicRegistrationWidget> {
  GroupController groupController = GroupController.instance;
  LocationController locationController = LocationController.locationController;
  AlcoholicController alcoholicController =
      AlcoholicController.alcoholicController;

  late Stream<List<SupportedArea>> supportedAreasStream;
  late List<String> items;

  String? selectedValue;

  Color textColor = Colors.green;
  late DropdownButton2<String> dropDowButton;

  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    supportedAreasStream = locationController.readAllSupportedAreas();
  }

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
                height: 5,
              ),

              // Alcoholic Phone Number.
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
                  invalidNumberMessage: '[Invalid Phone Number!]',
                  textAlignVertical: TextAlignVertical.center,
                  style:
                      TextStyle(fontSize: 16, color: MyApplication.logoColor1),
                  dropdownTextStyle:
                      TextStyle(fontSize: 16, color: MyApplication.logoColor1),
                  //onChanged: (phone) =>phoneNumberEditingController.text = phone.completeNumber,
                  initialCountryCode: 'ZA',
                  flagsButtonPadding: const EdgeInsets.only(right: 10),
                  keyboardType: TextInputType.phone,
                ),
              ),

              const SizedBox(
                height: 17,
              ),

              // Username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  keyboardType: TextInputType.name,
                  maxLength: 10,
                  style: TextStyle(color: MyApplication.logoColor1),
                  cursorColor: MyApplication.logoColor1,
                  controller: usernameEditingController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.account_circle,
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
                ),
              ),

              // Alcoholic Area Name
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
                height: 5,
              ),

              // Alcoholic Image
              GetBuilder<AlcoholicController>(builder: (_) {
                return alcoholicController.newAlcoholicImageURL!.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                            alcoholicController.newAlcoholicImageURL!),
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
                        'Capture/Pick Your Face',
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
                                debug.log(phoneNumberEditingController.text);
                                if (isValidPhoneNumber(
                                    '0${phoneNumberEditingController.text}')) {
                                  alcoholicController
                                      .captureAlcoholicProfileImageWithCamera(
                                          '0${phoneNumberEditingController.text}',
                                          usernameEditingController.text);
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
                                  alcoholicController
                                      .chooseAlcoholicProfileImageFromGallery(
                                          '0${phoneNumberEditingController.text}',
                                          usernameEditingController.text);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  keyboardType: TextInputType.name,
                  maxLength: 20,
                  style: TextStyle(color: MyApplication.logoColor1),
                  cursorColor: MyApplication.logoColor1,
                  controller: passwordEditingController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        Icon(Icons.lock, color: MyApplication.logoColor1),
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
                        // Sign Up Alcoholic
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
                              alcoholicController.setNewAlcoholicPassword(
                                  passwordEditingController.text);
                              debug.log(
                                  'Alcoholic Validation From AlcoholicRegistrationScreen');
                              // Create Alcoholic Now
                              if (alcoholicController
                                      .newAlcoholicPhoneNumber!.isNotEmpty &&
                                  alcoholicController
                                      .newAlcoholicUsername!.isNotEmpty &&
                                  alcoholicController
                                      .newAlcoholicPassword.isNotEmpty &&
                                  alcoholicController
                                      .newAlcoholicImageURL!.isNotEmpty &&
                                  alcoholicController
                                          .newAlcoholicProfileImageFile !=
                                      null) {
                                debug.log(
                                    'Alcoholic Validated From AlcoholicRegistrationScreen');
                                final auth = FirebaseAuth.instance;

                                await auth.verifyPhoneNumber(
                                  phoneNumber:
                                      '+27${phoneNumberEditingController.text}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    debug.log(
                                        '1. About To Signed In User From AlcoholicRegistrationScreen...');
                                    // ANDROID ONLY!
                                    // Sign the user in (or link) with the auto-generated credential
                                    await auth.signInWithCredential(credential);

                                    debug.log(
                                        '1. Successfully Signed In User From AlcoholicRegistrationScreen...');
                                    Future<AlcoholicSavingStatus>
                                        adminSavingStatus =
                                        alcoholicController.saveAlcoholic();

                                    adminSavingStatus.then((value) {
                                      if (value ==
                                          AlcoholicSavingStatus.unathourized) {
                                        debug.log(
                                            'AlcoholicSavingStatus.unathourized From AlcoholicRegistrationScreen...');
                                      } else if (value ==
                                          AlcoholicSavingStatus
                                              .adminAlreadyExist) {
                                        debug.log(
                                            'AlcoholicSavingStatus.adminAlreadyExist From AlcoholicRegistrationScreen...');
                                      } else if (value ==
                                          AlcoholicSavingStatus.loginRequired) {
                                        debug.log(
                                            'AlcoholicSavingStatus.loginRequired From AlcoholicRegistrationScreen...');
                                      } else if (value ==
                                          AlcoholicSavingStatus
                                              .incompleteData) {
                                        debug.log(
                                            'AlcoholicSavingStatus.incompleteData From AlcoholicRegistrationScreen...');
                                      } else {
                                        debug.log(
                                            '2. Successfully Saved User From AlcoholicRegistrationScreen...');
                                      }
                                    });
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      debug.log(
                                          '***The provided phone number is not valid***.');
                                    }

                                    // Handle other errors
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    Get.to(() => VerificationScreen(
                                          phoneNumber:
                                              '+27${phoneNumberEditingController.text}',
                                          verificationId: verificationId,
                                          forAdmin: false,
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
                                logoutUser(); // Logout currently logged in user.
                                Get.to(() => LoginWidget(
                                      forAdmin: false,
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

  Widget pickAreaName() {
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
              'Pick Your Area',
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
}
