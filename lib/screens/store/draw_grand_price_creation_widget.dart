import 'package:alco/controllers/store_controller.dart';
import 'package:flutter/material.dart';

import '../../controllers/user_controller.dart';
import '../../main.dart';

import 'dart:developer' as debug;

import '../users/groups_screen.dart';
import '../utils/page_navigation.dart';

class DrawGrandPriceCreationWidget extends StatefulWidget {
  TextEditingController descriptionController;
  int grandPriceIndex;
  DateTime dateTime;

  DrawGrandPriceCreationWidget(
      {required this.descriptionController,
      required this.grandPriceIndex,
      required this.dateTime});

  @override
  State createState() => DrawGrandPriceCreationWidgetState();
}

class DrawGrandPriceCreationWidgetState
    extends State<DrawGrandPriceCreationWidget> {
  UserController userController = UserController.instance;
  StoreController storeController = StoreController.storeController;
  DrawGrandPriceCreationWidgetState();

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            TextField(
              minLines: 1,
              maxLines: 10,
              style: TextStyle(color: MyApplication.logoColor1),
              cursorColor: MyApplication.logoColor1,
              controller: widget.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description ${widget.grandPriceIndex + 1}',
                /*prefixIcon:
                    Icon(Icons.description, color: MyApplication.logoColor1),*/
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
            singlePricePicker(),
          ],
        ),
      );

  Widget singlePricePicker() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Download Icon
          Expanded(
            child: IconButton(
              color: Colors.white,
              iconSize: MediaQuery.of(context).size.width * 0.15,
              icon: Icon(Icons.download, color: MyApplication.logoColor1),
              onPressed: () async {
                debug.log(
                    'drawGrandPrice Index ${widget.grandPriceIndex} Description ${widget.descriptionController.text}');
              },
            ),
          ),
          // Camera Icon
          Expanded(
            child: IconButton(
              color: Colors.white,
              iconSize: MediaQuery.of(context).size.width * 0.15,
              icon: Icon(Icons.camera_alt, color: MyApplication.logoColor1),
              onPressed: () async {
                storeController.captureGrandPriceProfileImageFromCamera(
                    widget.grandPriceIndex,
                    widget.descriptionController.text,
                    widget.dateTime.year,
                    widget.dateTime.month,
                    widget.dateTime.day,
                    widget.dateTime.hour,
                    widget.dateTime.minute);

                debug.log(
                    'drawGrandPrice Index ${widget.grandPriceIndex} Description ${widget.descriptionController.text}');
              },
            ),
          ),
          // Upload Icon
          Expanded(
            child: IconButton(
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * 0.15,
                icon: Icon(Icons.upload, color: MyApplication.logoColor1),
                onPressed: () async {
                  storeController.chooseGrandPriceProfileImageFromGallery(
                      widget.grandPriceIndex,
                      widget.descriptionController.text,
                      widget.dateTime.year,
                      widget.dateTime.month,
                      widget.dateTime.day,
                      widget.dateTime.hour,
                      widget.dateTime.minute);

                  debug.log(
                      'drawGrandPrice Index ${widget.grandPriceIndex} Description ${widget.descriptionController.text}');
                }),
          ),
        ],
      );
}
