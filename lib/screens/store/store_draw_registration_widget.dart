import 'package:alco/controllers/store_controller.dart';
import 'package:alco/screens/store/draw_grand_price_creation_widget.dart';
import 'package:alco/screens/utils/start_screen.dart';
import 'package:flutter/material.dart';

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

  bool hasGrandPrice(int grandPriceIndex) {
    switch (grandPriceIndex) {
      case 0:
        return storeController.drawGrandPrice1ImageFile != null &&
            description1EditingController.text.isNotEmpty;
      case 1:
        return storeController.drawGrandPrice2ImageFile != null &&
            description2EditingController.text.isNotEmpty;
      case 2:
        return storeController.drawGrandPrice3ImageFile != null &&
            description3EditingController.text.isNotEmpty;
      case 3:
        return storeController.drawGrandPrice4ImageFile != null &&
            description4EditingController.text.isNotEmpty;
      default:
        return storeController.drawGrandPrice5ImageFile != null &&
            description5EditingController.text.isNotEmpty;
    }
  }

  bool hasDrawGrandPriceWithoutImages(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return description1EditingController.text.isNotEmpty;
      case 2:
        return description2EditingController.text.isNotEmpty;
      case 3:
        return description3EditingController.text.isNotEmpty;
      case 4:
        return description4EditingController.text.isNotEmpty;
      default:
        return description5EditingController.text.isNotEmpty;
    }
  }

  bool isValidInputWithoutImages() {
    if (hasDrawGrandPriceWithoutImages(0) &&
        hasDrawGrandPriceWithoutImages(1) &&
        hasDrawGrandPriceWithoutImages(2) &&
        hasDrawGrandPriceWithoutImages(3) &&
        hasDrawGrandPriceWithoutImages(4)) {
      return true;
    }

    if (hasDrawGrandPriceWithoutImages(0) &&
        hasDrawGrandPriceWithoutImages(1) &&
        hasDrawGrandPriceWithoutImages(2) &&
        hasDrawGrandPriceWithoutImages(3)) {
      return true;
    }

    if (hasDrawGrandPriceWithoutImages(0) &&
        hasDrawGrandPriceWithoutImages(1) &&
        hasDrawGrandPriceWithoutImages(2)) {
      return true;
    }

    if (hasDrawGrandPriceWithoutImages(0) &&
        hasDrawGrandPriceWithoutImages(1)) {
      return true;
    }

    if (hasDrawGrandPriceWithoutImages(0)) {
      return true;
    }

    return false;
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
              Navigator.pop(context);
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

  Widget signInButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            color: MyApplication.logoColor1,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            )),
        child: InkWell(
          onTap: () async {
            if (isValidInputWithoutImages()) {
              final result = await storeController.createStoreDraw();

              // Does not go to the next screen.
              if (result == StoreDrawSavingStatus.saved) {
                Navigator.of(
                        context) /*
                .pushNamed(
                  MyRouteGenerator.id,
                );*/
                    .push(CustomPageRoute(child: StartScreen()));
              }
            }
          },
          child: const Center(
            child: Text(
              'Create Group',
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
