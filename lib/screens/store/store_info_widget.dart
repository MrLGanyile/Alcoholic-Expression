import 'package:firebase_storage/firebase_storage.dart';

import '../../controllers/store_controller.dart';
import '../../models/locations/converter.dart';
import '../../models/stores/store_draw.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/locations/section_name.dart';

import 'dart:developer' as debug;

// Branch : store_resources_crud ->  view_stores_front_end
class StoreInfoWidget extends StatefulWidget {
  String storeName;
  String storeId;
  String storeImageURL;
  SectionName sectionName;

  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  StoreInfoWidget({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.storeImageURL,
    required this.sectionName,
  });

  Column retrieveStoreDetails(BuildContext context) {
    debug.log('store info widget retrieveStoreDetails...');
    // Information About The Hosting Store.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The Name Of A Store On Which The Winner Won From.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Store Name',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    color: MyApplication.storeInfoTextColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  storeName,
                  style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storeInfoTextColor,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),

        // The Location Of A Store On Which The Winner Won From.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Store Home',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storeInfoTextColor,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  Converter.asString(sectionName),
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.storeInfoTextColor,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  AspectRatio retrieveStoreImage(BuildContext context, String storeImage) {
    debug.log('store info widget retrieveStoreImage...');
    // The Image Of A Store On Which The Winner Won From.
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(storeImage)),
        ),
      ),
    );
  }

  Future<String> createStoreImageURL() {
    return storageReference.child(storeImageURL).getDownloadURL();
  }

  @override
  State<StatefulWidget> createState() => StoreInfoWidgetState();
}

class StoreInfoWidgetState extends State<StoreInfoWidget> {
  StoreController storeController = StoreController.storeController;
  late List<StoreDraw> storeDraws;

  @override
  void initState() {
    super.initState();
    storeDraws =
        storeController.findStoreDraws(widget.storeId) as List<StoreDraw>;
  }

  int findSpecialDateIndex() {
    DateTime now = DateTime.now();

    for (int i = 0; i < storeDraws.length; i++) {
      if (storeDraws[i].drawDateAndTime.year == now.year &&
          storeDraws[i].drawDateAndTime.month == now.month &&
          storeDraws[i].drawDateAndTime.day == now.day) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    debug.log('store info widget build...');
    return FutureBuilder(
        future: widget.createStoreImageURL(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                    height: 150,
                    child: widget.retrieveStoreImage(
                        context, snapshot.data as String)),
                SizedBox(
                  height: 50,
                  child: widget.retrieveStoreDetails(context),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            debug.log('Error Fetching Store Image - ${snapshot.error}');
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
