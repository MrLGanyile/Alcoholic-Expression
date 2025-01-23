import 'package:flutter/material.dart';

import '../main.dart';

typedef OnPhoneNumberChanged = Function(int, String);
typedef OnUsernameChanged = Function(int, String);

class SingleMemberTextField extends StatefulWidget {
  TextEditingController controller;
  String labelText;
  bool isForUserName;
  int memberIndex;
  OnPhoneNumberChanged? onPhoneNumberChanged;
  OnUsernameChanged? onUsernameChanged;

  SingleMemberTextField(
      {required this.controller,
      required this.labelText,
      required this.memberIndex,
      this.isForUserName = true,
      this.onPhoneNumberChanged,
      this.onUsernameChanged});

  @override
  State<StatefulWidget> createState() => SingleMemberTextFieldState();
}

class SingleMemberTextFieldState extends State<SingleMemberTextField> {
  @override
  Widget build(BuildContext context) => TextField(
        onChanged: !widget.isForUserName
            ? widget.onPhoneNumberChanged!(
                widget.memberIndex, widget.controller.text)
            : widget.onUsernameChanged!(
                widget.memberIndex, widget.controller.text),
        style: TextStyle(color: MyApplication.logoColor1),
        cursorColor: MyApplication.logoColor1,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: widget.isForUserName
              ? Icon(Icons.account_circle, color: MyApplication.logoColor1)
              : Icon(Icons.phone, color: MyApplication.logoColor1),
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
