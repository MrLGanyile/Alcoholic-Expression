import 'package:alco/controllers/user_controller.dart';

import '/controllers/competition_controller.dart';

import '../../models/users/group.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'single_group_widget.dart';
import 'dart:developer' as debug;

// Branch : group_resources_crud ->  view_groups
class GroupsScreen extends StatefulWidget {
  static const String id = "GroupsScreen";
  const GroupsScreen({
    super.key,
  });

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  CompetitionController competitionController =
      CompetitionController.competitionController;
  UserController userController = UserController.instance;
  late Stream<List<Group>> groupsStream;
  late List<Group> allGroups;

  @override
  void initState() {
    super.initState();

    groupsStream = userController.readAllGroups();
  }

  @override
  Widget build(BuildContext context) => Container(
      height: 300,
      decoration: BoxDecoration(
        color: MyApplication.scaffoldColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: StreamBuilder<List<Group>>(
          stream: groupsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allGroups = snapshot.data!;
              allGroups.sort();

              return ListView.builder(
                itemCount: allGroups.length,
                itemBuilder: ((context, index) {
                  return SingleGroupWidget(competitorsGroup: allGroups[index]);
                }),
              );
            } else if (snapshot.hasError) {
              debug.log("Error Fetching Data - ${snapshot.error}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }));
}
