import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../controllers/store_controller.dart';
import '../../models/users/group.dart';
import 'dart:developer' as debug;

// Branch : competition_resources_crud ->  view_competitions
class GroupCompetitorWidget extends StatelessWidget {
  Group group;

  StoreController storeController = StoreController.storeController;
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  late List<Reference> groupMembersImageReferences;

  GroupCompetitorWidget({
    required this.group,
  });

  Future<String> retrieveGroupImageURL() {
    return storageReference.child(group.groupImageURL).getDownloadURL();
  }

  AspectRatio retrieveGroupImage(String groupImageURL) {
    // The Image Of A Store On Which The Winner Won From.
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(groupImageURL)),
        ),
      ),
    );
  }

  Future<ListResult> findGroupMembersImageURLs() async {
    return storageReference
        .child('group_members/${group.groupCreatorPhoneNumber}')
        .listAll();
  }

  Widget createGroupParticipant(BuildContext context, int memberIndex) {
    return FutureBuilder(
        future: groupMembersImageReferences[memberIndex].getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 12,
                  backgroundImage: NetworkImage(snapshot.data as String),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            debug.log("Error Fetching Data - ${snapshot.error}");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        });
    ;
  }

  Widget createGroupMembers(BuildContext context) {
    Column column;
    Row row;

    List<Widget> rowChildren;
    List<Widget> columnChildren;

    if (groupMembersImageReferences.length <= 4) {
      rowChildren = [];
      for (int i = 0; i < groupMembersImageReferences.length; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      return row;
    } else if (groupMembersImageReferences.length <= 8) {
      columnChildren = [];
      rowChildren = [];
      for (int i = 0; i < 4; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);

      rowChildren = [];
      for (int i = 4; i < groupMembersImageReferences.length; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);
      column = Column(children: columnChildren);
      return column;
    } else {
      columnChildren = [];
      rowChildren = [];
      for (int i = 0; i < 4; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);

      rowChildren = [];
      for (int i = 4; i < 8; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);
      rowChildren = [];
      for (int i = 8; i < groupMembersImageReferences.length; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);
      column = Column(children: columnChildren);
      return column;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Group Image
      FutureBuilder(
          future: retrieveGroupImageURL(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return retrieveGroupImage(snapshot.data as String);
            } else if (snapshot.hasError) {
              debug.log(
                  'Error Fetching Group Competitor Image Data - ${snapshot.error}');
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      const SizedBox(
        height: 5,
      ),
      // Group Members
      FutureBuilder(
          future: findGroupMembersImageURLs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ListResult allDownloadURLs = snapshot.data! as ListResult;

              if (allDownloadURLs.items.length > 12) {
                List<Reference> falseImagesReferences = [];
                int randomStartIndex =
                    Random().nextInt(allDownloadURLs.items.length - 12);
                int randomNumberOfGroupMembers = 1 + Random().nextInt(12);

                for (int index = randomStartIndex;
                    index < randomStartIndex + randomNumberOfGroupMembers;
                    index++) {
                  falseImagesReferences.add(allDownloadURLs.items[index]);
                }
                groupMembersImageReferences = falseImagesReferences;
              } else {
                groupMembersImageReferences = allDownloadURLs.items;
              }

              return createGroupMembers(context);
            } else if (snapshot.hasError) {
              debug
                  .log("Error Fetching Group Members Data - ${snapshot.error}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      const SizedBox(
        height: 5,
      ),
    ]);
  }
}
