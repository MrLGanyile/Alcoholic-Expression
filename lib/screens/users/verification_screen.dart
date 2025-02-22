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

  VerificationScreen(
      {Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  GroupController groupController = GroupController.instance;

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
              TextField(
                controller: otpController,
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
                      PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text);
                      debug.log(
                          'Signed In Successfully From VerificationScreen');
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
