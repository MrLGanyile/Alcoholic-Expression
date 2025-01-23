import 'package:alco/controllers/share_dao_functions.dart';
import 'package:alco/screens/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'dart:developer' as debug;

import 'page_navigation.dart';

class VerificationScreen extends StatefulWidget {
  String phoneNumber;
  String correctPin;

  VerificationScreen({required this.phoneNumber, required this.correctPin});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget _resendCodeLink() => Text(
          "Didn't the code,\nResend Code?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 15,
            color: Theme.of(context).colorScheme.primary,
          ),
        );

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
              !showProgressBar
                  ? pinInputForm()
                  : const SimpleCircularProgressBar(),
              _resendCodeLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget pinInputForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Pinput(
            validator: ((value) {
              debug.log(value!);
              debug.log('${widget.correctPin} ${widget.phoneNumber}');

              if (value == widget.correctPin) {
                return null;
              } else {
                return 'Incorrect Pin';
              }
            }),
            onCompleted: (userPin) {
              showProgressBar = true;
              if (userPin == widget.correctPin) {
                Navigator.of(context)
                    .push(CustomPageRoute(child: HomeWidget()));
              }
              showProgressBar = false;
            },
            errorBuilder: (errorText, userPin) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    errorText ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          ),
          TextButton(
              onPressed: () {
                formKey.currentState!.validate();
              },
              child: const Text('Validate')),
        ],
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
