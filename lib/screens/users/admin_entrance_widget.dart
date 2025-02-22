import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../store/store_draw_registration_widget.dart';

class AdminEntranceWidget extends StatelessWidget {
  const AdminEntranceWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Administration',
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      color: MyApplication.attractiveColor1)),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 20,
                color: MyApplication.logoColor2,
                onPressed: (() {
                  Get.back();
                }),
              ),
              elevation: 0,
            ),
            body: const Expanded(child: StoreDrawRegistrationWidget())),
      );
}
