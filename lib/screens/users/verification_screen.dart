import 'package:alco/controllers/admin_controller.dart';
import 'package:alco/controllers/alcoholic_controller.dart';
import 'package:alco/controllers/share_dao_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../controllers/group_controller.dart';
import '../../main.dart';

import 'package:flutter/material.dart';

import 'dart:developer' as debug;

// Branch : group_resources_crud ->  create_group_resources_front_end
class VerificationScreen extends StatefulWidget {
  String phoneNumber;
  String verificationId;
  bool forAdmin;

  VerificationScreen(
      {Key? key,
      required this.phoneNumber,
      required this.verificationId,
      required this.forAdmin})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  GroupController groupController = GroupController.instance;
  AdminController adminController = AdminController.instance;
  AlcoholicController alcoholicController =
      AlcoholicController.alcoholicController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  _headingText(),
                  const SizedBox(
                    height: 20,
                  ),
                  _subHeadingText(),
                  const SizedBox(
                    height: 20,
                  ),
                  _numberText()
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: TextStyle(color: MyApplication.logoColor1),
                  cursorColor: MyApplication.logoColor1,
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    prefixIcon:
                        Icon(Icons.numbers, color: MyApplication.logoColor1),
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: MyApplication.logoColor1,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: otpController.text);
                      final auth = FirebaseAuth.instance;
                      await auth.signInWithCredential(credential);

                      loginUser(widget.phoneNumber, widget.forAdmin);

                      if (widget.forAdmin) {
                        Future<AdminSavingStatus> adminSavingStatus =
                            adminController.saveAdmin();

                        adminSavingStatus.then((value) {
                          if (value == AdminSavingStatus.unathourized) {
                            debug.log(
                                'AdminSavingStatus.unathourized From AdminRegistrationScreen...');
                          } else if (value ==
                              AdminSavingStatus.adminAlreadyExist) {
                            debug.log(
                                'AdminSavingStatus.adminAlreadyExist From AdminRegistrationScreen...');
                          } else if (value == AdminSavingStatus.loginRequired) {
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
                      } else {
                        Future<AlcoholicSavingStatus> adminSavingStatus =
                            alcoholicController.saveAlcoholic();

                        adminSavingStatus.then((value) {
                          if (value == AlcoholicSavingStatus.unathourized) {
                            debug.log(
                                'AlcoholicSavingStatus.unathourized From AlcoholicRegistrationScreen...');
                          } else if (value ==
                              AlcoholicSavingStatus.adminAlreadyExist) {
                            debug.log(
                                'AlcoholicSavingStatus.adminAlreadyExist From AlcoholicRegistrationScreen...');
                          } else if (value ==
                              AlcoholicSavingStatus.loginRequired) {
                            debug.log(
                                'AlcoholicSavingStatus.loginRequired From AlcoholicRegistrationScreen...');
                          } else if (value ==
                              AlcoholicSavingStatus.incompleteData) {
                            debug.log(
                                'AlcoholicSavingStatus.incompleteData From AlcoholicRegistrationScreen...');
                          } else {
                            debug.log(
                                'Successfully Saved User From AlcoholicRegistrationScreen...');
                          }
                        });
                      }
                      Get.close(2);
                    } catch (error) {
                      Get.snackbar('Error', 'Error Signing The User In.');
                      debug.log('Error Signing User From VerificationScreen');
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _headingText() => const Text(
        'Verification',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
      );

  Widget _subHeadingText() => const Text(
        'Enter the code sent to te number.',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 15,
          color: Colors.black38,
        ),
      );

  Widget _numberText() => Text(
        widget.phoneNumber,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      );
}
