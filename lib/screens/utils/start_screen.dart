import 'package:alco/screens/users/group_registration_widget.dart';
import 'package:get/get.dart';

import '/screens/store/stores_widget.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

import '../users/groups_screen.dart';
import 'home_widget.dart';

class StartScreen extends StatefulWidget {
  StartScreen({
    super.key,
  });

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  List<String> titles = ['Recent Wins', 'All Stores', 'Groups'];

  void updateCurrentIndex(int index) {
    setState(() => currentIndex = index);
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: currentIndex != 2
            ? const SizedBox.shrink()
            : FloatingActionButton(
                onPressed: (() {
                  Get.to(() => GroupRegistrationWidget());
                }),
                backgroundColor: MyApplication.attractiveColor1,
                child: const Icon(
                  Icons.add,
                ),
              ),
        backgroundColor: MyApplication.scaffoldColor,
        appBar: AppBar(
          backgroundColor: MyApplication.scaffoldColor,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 30,
            color: MyApplication.logoColor2,
            onPressed: (() {}),
          ),
          title: Text(
            titles[currentIndex],
            style: TextStyle(
              fontSize: MyApplication.infoTextFontSize,
              color: MyApplication.attractiveColor1,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            // Not Needed
            IconButton(
              icon: const Icon(Icons.search),
              iconSize: 30,
              color: MyApplication.logoColor2,
              onPressed: (() {}),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              iconSize: 30,
              color: MyApplication.logoColor2,
              onPressed: (() {}),
            ),
          ],
          /*flexibleSpace: Container(
          decoration: BoxDecoration(
            color: MyApplication.scaffoldColor,
          ),
        ),*/
          bottom: TabBar(
            onTap: updateCurrentIndex,
            labelColor: MyApplication.logoColor1,
            controller: _tabController,
            indicatorColor: MyApplication.logoColor2,
            indicatorWeight: 5,
            //dividerHeight: 0,
            indicatorPadding: const EdgeInsets.only(bottom: 8),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: MyApplication.attractiveColor1,
                ),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.local_drink,
                    color: MyApplication.attractiveColor1),
                text: 'Stores',
              ),
              Tab(
                icon: Icon(Icons.group, color: MyApplication.attractiveColor1),
                text: 'Groups',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: MyApplication.scaffoldColor,
            ),
            child: TabBarView(controller: _tabController, children: [
              HomeWidget(),
              //DatePicker(),
              StoresWidget(),
              GroupsScreen(),
            ]),
          ),
        ),
      );
}
