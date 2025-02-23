import 'package:alco/controllers/share_dao_functions.dart';
import 'package:alco/screens/users/admin_entrance_widget.dart';

import '../store/store_draw_registration_widget.dart';
import '../users/admin_registration_widget.dart';
import '../users/alcoholic_registration_widget.dart';
import '../users/alcoholics_widgets.dart';
import '/screens/users/group_registration_widget.dart';
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
  double listTilesFontSize = 15;
  double listTilesIconSize = 30;
  List<String> titles = [
    'Recent Wins',
    'All Stores',
    'Groups',
    'Administration'
  ];

  void updateCurrentIndex(int index) {
    setState(() => currentIndex = index);
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
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
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.5,
          backgroundColor: Colors.black.withOpacity(0.9),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.info,
                  size: listTilesIconSize,
                ),
                iconColor: MyApplication.logoColor1,
                textColor: MyApplication.logoColor2,
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: listTilesFontSize,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AboutDialog(
                      applicationIcon: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),
                      applicationLegalese: 'Lealese',
                      applicationName: 'Alco',
                      applicationVersion: 'version 1.0.0',
                      children: [Text('Cheers!!!')],
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.admin_panel_settings, size: listTilesIconSize),
                iconColor: MyApplication.logoColor1,
                textColor: MyApplication.logoColor2,
                title: Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: listTilesFontSize,
                  ),
                ),
                onTap: () => Get.to(() => AdminEntranceWidget()),
              ),
              ListTile(
                leading:
                    Icon(Icons.location_searching, size: listTilesIconSize),
                iconColor: MyApplication.logoColor1,
                textColor: MyApplication.logoColor2,
                title: Text(
                  'Areas',
                  style: TextStyle(
                    fontSize: listTilesFontSize,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.group, size: listTilesIconSize),
                iconColor: MyApplication.logoColor1,
                textColor: MyApplication.logoColor2,
                title: Text(
                  'Users',
                  style: TextStyle(
                    fontSize: listTilesFontSize,
                  ),
                ),
                onTap: () => Get.to(() => AlcoholicsWidget()),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, size: listTilesIconSize),
                iconColor: MyApplication.logoColor1,
                textColor: MyApplication.logoColor2,
                title: Text(
                  'Join',
                  style: TextStyle(
                    fontSize: listTilesFontSize,
                  ),
                ),
                onTap: () => Get.to(() => const AlcoholicRegistrationWidget()),
              ),
              const Divider(
                height: 5,
              ),
              ListTile(
                  leading: Icon(Icons.logout, size: listTilesIconSize),
                  iconColor: MyApplication.logoColor1,
                  textColor: MyApplication.logoColor2,
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: listTilesFontSize,
                    ),
                  ),
                  onTap: () {
                    if (currentlyLoggedInUser != null) {
                      logoutUser();

                      Get.to(() => AlertDialog(
                            title: Text(
                              'Goodbye',
                              style: TextStyle(
                                  fontSize: listTilesFontSize,
                                  color: MyApplication.storesTextColor),
                            ),
                            content: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                                child: Text(
                                  'You Have Successfully Logged Out.',
                                  style: TextStyle(
                                      fontSize: listTilesFontSize - 5,
                                      color: MyApplication.storesTextColor),
                                )),
                          ));
                    } else {
                      Get.snackbar('Error', 'You Are Not Currently Logged In.');
                    }
                  }),
            ],
          ),
        ),
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
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 30,
              color: MyApplication.logoColor2,
              onPressed: (() {
                Scaffold.of(context).openDrawer();
              }),
            );
          }),
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
              Tab(
                icon: Icon(Icons.admin_panel_settings,
                    color: MyApplication.attractiveColor1),
                text: 'Admin',
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
              StoresWidget(),
              const GroupsScreen(),
              const StoreDrawRegistrationWidget(),
            ]),
          ),
        ),
      );
}
