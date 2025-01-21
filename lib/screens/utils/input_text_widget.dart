
import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget{
  
  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetReference;
  final String labelString;
  final BallisticScrollActivity isObscure;

  InputTextWidget({
    required this.textEditingController,
    this.iconData,
    this.assetReference,
    required this.labelString,
    required this.isObscure
  });

  @override 
  Widget build(BuildContext context){
    return const Placeholder();
  }
}