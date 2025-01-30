import 'package:flutter/material.dart';
import 'date_picker_helper.dart';
import 'dart:developer' as debug;

class DatePicker extends StatefulWidget{
  
  String text = 'Pick Delivery Date';
  DateTime validationDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime deliveryDate = DateTime.now().subtract(const Duration(days: 1));

  DatePicker({Key? key}) : super(key: key);

  @override 
  _DatePickerState createState() => _DatePickerState();

}

class _DatePickerState extends State<DatePicker>{

  
  

  @override
  void initState() {
    // This method execute only when this state is created for the first time.
    // It get executed befor the build method.
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    // This method will get executed whenever DatePicker get external data.
    // This method is called before the build method.
    super.didUpdateWidget(oldWidget);
  }
  

  // our text controller
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => DatePickerHelper(text:widget.text,onClicked: ()=>pickDate(context));
  

  Future pickDate(BuildContext context) async{
    debug.log('...................');
    final initialDate = DateTime.now().add(const Duration(days: 3));
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 50))
    );
      
    if(newDate==null){
      return;
    }

    setState((){
      widget.deliveryDate=newDate;
      widget.text = 'Delivery Date - ${widget.deliveryDate.day}\\${widget.deliveryDate.month}\\${widget.deliveryDate.year}';
    });
  }

}

