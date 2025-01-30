import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef MyCallBack = Function();

class DatePickerHelper extends StatelessWidget{

  final MyCallBack onClicked;
  String text;
  

  DatePickerHelper({Key? key, required this.onClicked,required this.text}) : super(key: key);

  
  @override
  Widget build(BuildContext context){
    
    double buttonWidth = MediaQuery.of(context).size.width/1.2;
    double buttonBorderRadius = 30;

    return Container(
      width:buttonWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        color: Colors.white,
      ),
      child:ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(35),
          primary: Colors.blue,
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          )
        ),
      ),
    );
  }
}