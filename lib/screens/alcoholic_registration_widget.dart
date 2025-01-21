import 'package:alco/screens/page_navigation.dart';
import 'package:alco/screens/verification_screen.dart';

import '/models/locations/supported_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_container/easy_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../controllers/authentication_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/user_controller.dart';
import '../main.dart';

import 'utils/globals.dart';
import 'dart:developer' as debug;

// groups_crud -> create_group_front_end
class AlcoholicRegistrationWidget extends StatefulWidget {
  static const id = 'Alcoholic-Registration-Widget';

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
  AuthenticationController authenticationController =
      AuthenticationController.instanceAuth;
  UserController userController = UserController.instance;
  LocationController locationController = LocationController.locationController;

  late Stream<List<SupportedArea>> supportedAreasStream;
  late List<String> items;

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  Color textColor = Colors.green;
  late DropdownButton2<String> dropDowButton;

  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();

  String? enteredCode;
  late String correctCode;

  @override
  void initState() {
    super.initState();

    supportedAreasStream = locationController.readAllSupportedAreas();
  }

  void setVerificationCode(String? code) {
    setState(() {
      enteredCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
            size: 20,
            color: MyApplication.attractiveColor1,
          ),
          title: const Text(
            'Registration',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: MyApplication.attractiveColor1,
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Capture Alcoholic Face',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MyApplication.logoColor1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      color: Colors.white,
                      iconSize: MediaQuery.of(context).size.width * 0.15,
                      icon: Icon(Icons.camera_alt,
                          color: MyApplication.logoColor2),
                      onPressed: () {
                        userController.captureAlcoholicProfileImageWithCamera();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Alcoholic Username
              TextField(
                style: TextStyle(color: MyApplication.logoColor1),
                cursorColor: MyApplication.logoColor1,
                controller: usernameEditingController,
                decoration: InputDecoration(
                  labelText: 'Enter Username',
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
              const SizedBox(
                height: 10,
              ),
              // Store Area Name
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
              // Alcoholic Phone Number
              EasyContainer(
                elevation: 0,
                height: 65,
                borderRadius: 6,
                color: MyApplication.scaffoldColor,
                showBorder: true,
                borderColor: MyApplication.logoColor2,
                child: IntlPhoneField(
                  controller: phoneNumberEditingController,
                  cursorColor: MyApplication.logoColor1,
                  autofocus: false,
                  invalidNumberMessage: 'Invalid Phone Number!',
                  textAlignVertical: TextAlignVertical.center,
                  style:
                      TextStyle(fontSize: 16, color: MyApplication.logoColor1),
                  dropdownTextStyle:
                      TextStyle(fontSize: 16, color: MyApplication.logoColor1),
                  //onChanged: (phone) =>phoneNumberEditingController.text = phone.completeNumber,
                  initialCountryCode: 'ZA',
                  flagsButtonPadding: const EdgeInsets.only(right: 10),
                  showDropdownIcon: true,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(
                height: 10,
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
                          height: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: MyApplication.logoColor1,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: InkWell(
                            onTap: () async {
                              showProgressBar = true;

                              // Create Alcoholic Now
                              if (true /*usernameEditingController.text.isNotEmpty &&
                                  phoneNumberEditingController
                                      .text.isNotEmpty &&
                                  dropDowButton.value != null &&
                                  userController.alcoholicProfileImageFile !=
                                      null*/
                                  ) {
                                /*Navigator.of(context).push(
                                  CustomPageRoute(
                                      child: VerifyPhoneNumberScreen(
                                    phoneNumber:
                                        phoneNumberEditingController.text,
                                  )),
                                );*/

                                final auth = FirebaseAuth.instance;
                                await auth.verifyPhoneNumber(
                                  phoneNumber: '+27661813561',

                                  /* This handler will only be called on Android devices which 
                                  support automatic SMS code resolution.When the SMS code is delivered 
                                  to the device, Android will automatically verify the SMS code without 
                                  requiring the user to manually input the code. If this event occurs, 
                                  a PhoneAuthCredential is automatically provided which can be used to 
                                  sign-in with or link the user's phone number.
                                  */
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    debug.log('1. About To Signed In User...');
                                    // ANDROID ONLY!
                                    // Sign the user in (or link) with the auto-generated credential
                                    await auth.signInWithCredential(credential);

                                    debug.log(
                                        '1. Successfully Signed In User...');
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      debug.log(
                                          'The provided phone number is not valid.');
                                    }

                                    // Handle other errors
                                  },

                                  /*
                                  When Firebase sends an SMS code to the device, this handler is 
                                  triggered with a verificationId and resendToken (A resendToken 
                                  is only supported on Android devices, iOS devices will always 
                                  return a null value). Once triggered, it would be a good time to 
                                  update your application UI to prompt the user to enter the SMS 
                                  code they're expecting. Once the SMS code has been entered, you 
                                  can combine the verification ID with the SMS code to create a new 
                                  PhoneAuthCredential:
                                  */

                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    showProgressBar = true;
                                    Navigator.of(context).push(CustomPageRoute(
                                        child: VerificationScreen(
                                      phoneNumber:
                                          phoneNumberEditingController.text,
                                      correctPin: verificationId,
                                    )));
                                    // Update the UI - wait for the user to enter the SMS code

                                    // Create a PhoneAuthCredential with the code
                                    PhoneAuthCredential credential =
                                        PhoneAuthProvider.credential(
                                            verificationId: verificationId,
                                            smsCode: enteredCode!);

                                    // Sign the user in (or link) with the credential
                                    await auth.signInWithCredential(credential);
                                  },
                                  /*
                                  By default, Firebase will not re-send a new SMS message if 
                                  it has been recently sent. You can however override this 
                                  behavior by re-calling the verifyPhoneNumber method with 
                                  the resend token to the forceResendingToken argument. If 
                                  successful, the SMS message will be resent.
                                  */
                                  /*
                                  On Android devices which support automatic SMS code resolution, 
                                  this handler will be called if the device has not automatically 
                                  resolved an SMS message within a certain timeframe. Once the 
                                  timeframe has passed, the device will no longer attempt to resolve 
                                  any incoming messages. By default, the device waits for 30 seconds 
                                  however this can be customized with the timeout argument:
                                  */
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );

                                /*setState(() {
                                  showProgressBar = true;
                                });
                                userController.saveAlcoholic(
                                    userController.alcoholicProfileImageFile!,
                                    phoneNumberEditingController.text,
                                    Converter.toSectionName(
                                        dropDowButton.value!));*/
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
                                // Get.to(const AlcoholicRegistrationWidget());
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
                    )
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
