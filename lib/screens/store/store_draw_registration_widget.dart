import 'package:alco/controllers/store_controller.dart';
import 'package:alco/screens/store/draw_grand_price_creation_widget.dart';
import 'package:alco/screens/utils/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../users/groups_screen.dart';
import '../utils/page_navigation.dart';
import 'date_picker.dart';

class StoreDrawRegistrationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoreDrawRegistrationWidgetState();
}

class StoreDrawRegistrationWidgetState
    extends State<StoreDrawRegistrationWidget> {
  StoreController storeController = StoreController.storeController;

  TextEditingController description1EditingController = TextEditingController();

  TextEditingController description2EditingController = TextEditingController();

  TextEditingController description3EditingController = TextEditingController();

  TextEditingController description4EditingController = TextEditingController();

  TextEditingController description5EditingController = TextEditingController();

  DateTime drawDate = DateTime(2025, 2, 2, 8, 5);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Registration',
              style: TextStyle(
                  fontSize: 14, color: MyApplication.attractiveColor1)),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 20,
            color: MyApplication.logoColor2,
            onPressed: (() {
              //Navigator.pop(context);
              Get.back();
            }),
          ),
          elevation: 0,
        ),
        body: Container(
          color: Colors.black,
          child: buildStoreDraw(),
        ),
      );

  Widget buildStoreDraw() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Logo
              CircleAvatar(
                backgroundImage: const AssetImage('assets/logo.png'),
                radius: MediaQuery.of(context).size.width * 0.15,
              ),
              const SizedBox(
                height: 10,
              ),
              DatePicker(),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                  descriptionController: description1EditingController,
                  grandPriceIndex: 0,
                  dateTime: drawDate),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                  descriptionController: description2EditingController,
                  grandPriceIndex: 1,
                  dateTime: drawDate),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                  descriptionController: description3EditingController,
                  grandPriceIndex: 2,
                  dateTime: drawDate),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                  descriptionController: description4EditingController,
                  grandPriceIndex: 3,
                  dateTime: drawDate),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                  descriptionController: description5EditingController,
                  grandPriceIndex: 4,
                  dateTime: drawDate),
              const SizedBox(
                height: 10,
              ),
              signInButton(),
            ],
          ),
        ),
      );

  bool hasPickedAllPrices() {
    return storeController.drawGrandPrice1ImageFile != null &&
        storeController.grandPrice1ImageURL!.isNotEmpty &&
        storeController.description1!.isNotEmpty &&
        storeController.drawGrandPrice2ImageFile != null &&
        storeController.grandPrice2ImageURL!.isNotEmpty &&
        storeController.description2!.isNotEmpty &&
        storeController.drawGrandPrice3ImageFile != null &&
        storeController.grandPrice3ImageURL!.isNotEmpty &&
        storeController.description3!.isNotEmpty &&
        storeController.drawGrandPrice4ImageFile != null &&
        storeController.grandPrice4ImageURL!.isNotEmpty &&
        storeController.description4!.isNotEmpty &&
        storeController.drawGrandPrice5ImageFile != null &&
        storeController.grandPrice5ImageURL!.isNotEmpty &&
        storeController.description5!.isNotEmpty;
  }

  Widget signInButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        //width: double.maxFinite, visible width
        //height: double.maxFinite visible height
        decoration: BoxDecoration(
            color: MyApplication.logoColor1,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            )),
        child: InkWell(
          onTap: () async {
            if (hasPickedAllPrices()) {
              final result = await storeController.createStoreDraw();

              // Does not go to the next screen.
              if (result == StoreDrawSavingStatus.saved) {
                Get.to(() => StartScreen());
              }
            }
          },
          child: const Center(
            child: Text(
              'Create Draw',
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
