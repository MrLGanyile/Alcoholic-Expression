import 'dart:developer' as debug;

import '/controllers/store_controller.dart';
import '/screens/store/store_name_info_widget.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

import '../../models/stores/store_name_info.dart';

// Branch : store_resources_crud ->  view_stores_front_end
class StoresWidget extends StatefulWidget {
  StoresWidget({
    super.key,
  });

  @override
  StoresWidgetState createState() => StoresWidgetState();
}

// Firstly start by reading the documents of StoreNameInfo Collection.
class StoresWidgetState extends State<StoresWidget> {
  StoreController storeController = StoreController.storeController;
  late Stream<List<StoreNameInfo>> storeNamesInfoStream;
  late List<StoreNameInfo> storeNamesInfo;

  @override
  void initState() {
    super.initState();

    storeNamesInfoStream = storeController.readAllStoreNameInfo();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: MyApplication.scaffoldColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: MyApplication.storeDataPadding,
          child: StreamBuilder<List<StoreNameInfo>>(
            stream: storeNamesInfoStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                storeNamesInfo = snapshot.data!;
                storeNamesInfo.sort();

                return ListView.builder(
                    itemCount: storeNamesInfo.length,
                    itemBuilder: ((context, index) {
                      StoreNameInfo storeNameInfo = storeNamesInfo[index];
                      return StoreNameInfoWidget(storeNameInfo: storeNameInfo);
                    }));
              } else if (snapshot.hasError) {
                debug.log(
                    "Error Fetching All Store Names Info Data - ${snapshot.error}");
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
      );
}
