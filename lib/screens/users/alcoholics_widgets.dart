import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../main.dart';
import '../../models/locations/converter.dart';
import '../../models/locations/supported_area.dart';
import '/controllers/alcoholic_controller.dart';
import '/models/users/alcoholic.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as debug;

class AlcoholicsWidget extends StatelessWidget {
  AlcoholicController alcoholicController =
      AlcoholicController.alcoholicController;
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  late Stream<List<SupportedArea>> supportedAreasStream =
      locationController.readAllSupportedAreas();
  late List<String> items;
  LocationController locationController = LocationController.locationController;
  late DropdownButton2<String> dropDowButton;

  AlcoholicsWidget({Key? key}) : super(key: key);

  Future<String> findProfileImageURL(String imageURL) async {
    return await storageReference.child(imageURL).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          color: MyApplication.attractiveColor1,
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: MyApplication.attractiveColor1,
      ),
      backgroundColor: MyApplication.scaffoldColor,
      body: GetBuilder<AlcoholicController>(builder: (_) {
        return StreamBuilder<List<Alcoholic>>(
          stream: alcoholicController.readAlcoholics(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Alcoholic> alcoholics = snapshot.data!;
              return Column(
                children: [
                  // Search Area
                  Expanded(
                    child: StreamBuilder<List<SupportedArea>>(
                      stream: supportedAreasStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> dbItems = [];
                          for (int areaIndex = 0;
                              areaIndex < snapshot.data!.length;
                              areaIndex++) {
                            dbItems.add(snapshot.data![areaIndex].toString());
                          }
                          items = dbItems;
                          return pickAreaName(context);
                        } else if (snapshot.hasError) {
                          debug.log(
                              "Error Fetching Supported Areas Data - ${snapshot.error}");
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  // Alcoholics For A Particular Area.
                  Expanded(
                    flex: 9,
                    child: allUsers(alcoholics),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              Get.snackbar('Error', snapshot.error.toString());
              debug.log("Error Fetching alcoholics Data - ${snapshot.error}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }),
    );
  }

  Widget pickAreaName(BuildContext context) {
    dropDowButton = DropdownButton2<String>(
      isExpanded: true,
      hint: Row(
        children: [
          Icon(
            Icons.location_searching,
            size: 22,
            color: MyApplication.logoColor1,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Township',
              style: TextStyle(
                fontSize: 14,
                color: MyApplication.logoColor2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storesTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: Converter.asString(alcoholicController.searchedSectionName!),
      onChanged: (String? value) {
        alcoholicController.setSearchedSectionName(value!);
      },
      buttonStyleData: ButtonStyleData(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.90,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: MyApplication.logoColor2,
          ),
          color: MyApplication.scaffoldColor,
        ),
        elevation: 0,
      ),
      iconStyleData: IconStyleData(
        icon: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        iconSize: 14,
        iconEnabledColor: MyApplication.logoColor2,
        iconDisabledColor: Colors.grey,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black,
        ),
        offset: const Offset(10, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
    );

    return DropdownButtonHideUnderline(child: dropDowButton);
  }

  Widget allUsers(List<Alcoholic> alcoholics) {
    List<Widget> columnChildren = [];
    List<Widget> rowChildren = [];

    Row row = Row();

    int index;
    for (index = 1; index <= alcoholics.length; index++) {
      rowChildren.add(singleUser(alcoholics[index - 1].profileImageURL,
          alcoholics[index - 1].username));
      if (index % 3 == 0) {
        row = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        );
        columnChildren.add(row);
        rowChildren = [];
      }
    }

    if (index % 3 != 0) {
      columnChildren.add(row);
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: columnChildren,
      ),
    );
  }

  Widget singleUser(String profileImageURL, String username) {
    return Expanded(
      child: FutureBuilder(
          future: findProfileImageURL(profileImageURL),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(snapshot.data! as String),
                            fit: BoxFit.contain),
                      ),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          color: MyApplication.storesTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              Get.snackbar('Error', snapshot.error.toString());
              debug
                  .log("Error Fetching Profile Image Data - ${snapshot.error}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
