import 'package:alco/controllers/share_dao_functions.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main.dart';
import '../store/store_draw_registration_widget.dart';

class LoginWidget extends StatelessWidget {
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  bool forAdmin;
  LoginWidget({required this.forAdmin});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Login',
              style: TextStyle(
                  fontSize: MyApplication.infoTextFontSize,
                  color: MyApplication.attractiveColor1)),
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
        body: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage('assets/logo.png'),
                    radius: MediaQuery.of(context).size.width * 0.15,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Alco',
                    style: TextStyle(
                        fontSize: MyApplication.infoTextFontSize,
                        color: MyApplication.logoColor1,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      minLines: 1,
                      maxLength: 10,
                      style: TextStyle(color: MyApplication.logoColor1),
                      cursorColor: MyApplication.logoColor1,
                      controller: phoneNumberEditingController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon:
                            Icon(Icons.phone, color: MyApplication.logoColor1),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      minLines: 1,
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: proceedButton(context),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget proceedButton(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: MyApplication.logoColor1,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            )),
        child: InkWell(
          onTap: () async {
            if (isCredentialsCorrect(phoneNumberEditingController.text,
                passwordEditingController.text, forAdmin)) {
              loginUser(phoneNumberEditingController.text, forAdmin);
              Get.close(2);
            } else {
              phoneNumberEditingController.clear();
              passwordEditingController.clear();
              Get.snackbar('Error', 'Incorrect Credentials.');
            }
          },
          child: const Center(
            child: Text(
              'Proceed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}
