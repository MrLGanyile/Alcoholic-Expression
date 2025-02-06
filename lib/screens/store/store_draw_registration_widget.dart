import 'package:alco/controllers/store_controller.dart';
import 'package:alco/screens/store/draw_grand_price_creation_widget.dart';
import 'package:alco/screens/utils/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import 'date_picker.dart';

import 'dart:developer' as debug;

import 'time_picker.dart';

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

  @override
  void initState() {
    super.initState();
    storeController.initiateHostingStore();
  }

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

  String displayTime() {
    if (storeController.drawDateHour! == -1 ||
        storeController.drawDateMinute == -1) {
      return 'HH:MM';
    } else {
      String time = '';

      if (storeController.drawDateHour! < 10) {
        time += '0${storeController.drawDateHour!}';
      } else {
        time += '${storeController.drawDateHour!}';
      }

      if (storeController.drawDateMinute! < 10) {
        time += ':0${storeController.drawDateMinute!}';
      } else {
        time += ':${storeController.drawDateMinute!}';
      }

      if ((storeController.drawDateHour! == 12 &&
              storeController.drawDateMinute! > 0) ||
          storeController.drawDateHour! > 12) {
        time += ' PM';
      } else {
        time += ' AM';
      }

      return time;
    }
  }

  String displayDate() {
    if (storeController.drawDateYear! < 2025 ||
        storeController.drawDateMonth == -1 ||
        storeController.drawDateDay == -1) {
      return 'YYY-MM-DD';
    } else {
      String date = '${storeController.drawDateYear}';

      if (storeController.drawDateMonth! < 10) {
        date += '-0${storeController.drawDateMonth}';
      } else {
        date += '-${storeController.drawDateMonth}';
      }

      if (storeController.drawDateDay! < 10) {
        date += '-0${storeController.drawDateDay}';
      } else {
        date += '-${storeController.drawDateDay}';
      }

      return date;
    }
  }

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
              const SizedBox(
                height: 10,
              ),
              GetBuilder<StoreController>(builder: (_) {
                return Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        DatePicker(),
                        Text(
                          displayDate(),
                          style: TextStyle(
                              color: MyApplication.logoColor2, fontSize: 14),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        TimePicker(),
                        Text(
                          displayTime(),
                          style: TextStyle(
                              color: MyApplication.logoColor2, fontSize: 14),
                        ),
                      ],
                    )),
                  ],
                );
              }),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                descriptionController: description1EditingController,
                grandPriceIndex: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                descriptionController: description2EditingController,
                grandPriceIndex: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                descriptionController: description3EditingController,
                grandPriceIndex: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                descriptionController: description4EditingController,
                grandPriceIndex: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              DrawGrandPriceCreationWidget(
                descriptionController: description5EditingController,
                grandPriceIndex: 4,
              ),
              const SizedBox(
                height: 10,
              ),
              signInButton(),
            ],
          ),
        ),
      );

  bool hasPickedAllPrices() {
    storeController.setDescription(0, description1EditingController.text);
    storeController.setDescription(1, description2EditingController.text);
    storeController.setDescription(2, description3EditingController.text);
    storeController.setDescription(3, description4EditingController.text);
    storeController.setDescription(4, description5EditingController.text);

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
              debug.log('About to go to the next page...');
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
