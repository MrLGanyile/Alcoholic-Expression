import 'package:alco/models/stores/draw_grand_price.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/Utilities/converter.dart';
import '../../models/users/group.dart';

import 'dart:developer' as debug;

// won_prices_crud -> read_won_prices
class CompetitionResultWidget extends StatelessWidget {
  Group wonGroup;
  DrawGrandPrice wonPrice;
  DateTime competitionEndTime;

  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  late List<Reference> groupMembersImageReferences;

  CompetitionResultWidget(
      {required this.wonGroup,
      required this.wonPrice,
      required this.competitionEndTime});

  Column retrieveGroupDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group name details
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Group Name',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storesTextColor,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wonGroup.groupName,
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.storesTextColor,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),

        // Group section details
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Group Home',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storesTextColor,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Converter.asString(wonGroup.groupSectionName),
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.storesTextColor,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),

        // Group area details
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Group Area',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    color: MyApplication.storesTextColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wonGroup.groupSpecificArea,
                  style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storesTextColor,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column retrieveGroupInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Home
        Row(
          children: [
            Expanded(
              child: Text(
                'Group Home',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.logoColor1,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Converter.asString(wonGroup.groupSectionName),
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.logoColor2,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),

        // Group Location
        Row(
          children: [
            Expanded(
              child: Text(
                'Group Area',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.logoColor1,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wonGroup.groupSpecificArea,
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.logoColor2,
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

  Column retrieveWonPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Won price
        Row(
          children: [
            Expanded(
              child: Text(
                'Won Price',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.logoColor1,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wonPrice.description,
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.logoColor2,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),

        // Lucky Date
        Row(
          children: [
            Expanded(
              child: Text(
                'Lucky Date',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.logoColor1,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  competitionEndTime.toString().substring(0, 16),
                  style: TextStyle(
                      fontSize: MyApplication.infoTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.logoColor2,
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

  Future<String> findWonPriceImageURL() async {
    return storageReference.child(wonPrice.imageURL).getDownloadURL();
  }

  AspectRatio retrieveWonPriceImage(
      BuildContext context, String wonGrandPriceImageURL) {
    return AspectRatio(
      aspectRatio: 8 / 2,
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(wonGrandPriceImageURL),
            //image: NetworkImage(store.picPath + store.picName)
          ),
        ),
      ),
    );
  }

  Future<String> findGroupCreatorImageURL() {
    return storageReference
        .child(wonGroup.groupCreatorImageURL)
        .getDownloadURL();
  }

  Future<ListResult> findGroupMembersImageURLs() async {
    return storageReference
        .child('group_members/${wonGroup.groupCreatorPhoneNumber}')
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
            debug.log("Error Fetching Group Members Data - ${snapshot.error}");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
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
    return SizedBox(
      //height: 550,
      child: Column(
        children: [
          // Store Name, Section & Area
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              // Creator & Won Price Image
              SizedBox(
                height: 150,
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Row(
                    children: [
                      // Winner
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, bottom: 5),
                            child: Column(
                              children: [
                                FutureBuilder(
                                    future: findGroupCreatorImageURL(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              snapshot.data as String),
                                        );
                                      } else if (snapshot.hasError) {
                                        debug.log(
                                            'Error Fetching Winner Image - ${snapshot.error}');
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                                Text(
                                  'Leader',
                                  style: TextStyle(
                                    color: MyApplication.logoColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  wonGroup.groupCreatorUsername,
                                  style: TextStyle(
                                    color: MyApplication.logoColor2,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  wonGroup.groupName,
                                  style: TextStyle(
                                    color: MyApplication.attractiveColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // WonPrice Image
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                              height: 140,
                              child: FutureBuilder(
                                  future: findWonPriceImageURL(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return retrieveWonPriceImage(
                                          context, snapshot.data as String);
                                    } else if (snapshot.hasError) {
                                      debug.log(
                                          'Error Fetching Won Price Image - ${snapshot.error}');
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }))),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: SizedBox(height: 40, child: retrieveWonPriceInfo(context)),
          ),

          // Members Of A Group
          FutureBuilder(
              future: findGroupMembersImageURLs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ListResult allDownloadURLs = snapshot.data! as ListResult;

                  /*if (allDownloadURLs.items.length > 12) {
                    List<Reference> falseImagesReferences = [];

                    for (int index = 0;
                        index < wonGroup.groupMembers.length;
                        index++) {
                      falseImagesReferences.add(allDownloadURLs.items[index]);
                    }
                    groupMembersImageReferences = falseImagesReferences;
                  } else {
                    groupMembersImageReferences = allDownloadURLs.items;
                  }*/

                  groupMembersImageReferences = allDownloadURLs.items;

                  return createGroupMembers(context);
                } else if (snapshot.hasError) {
                  debug.log(
                      "Error Fetching Group Members Data - ${snapshot.error}");
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
            height: 15,
          ),

          // Group Name & Won Price
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              // Group Location/Area Details
              SizedBox(height: 50, child: retrieveGroupInfo(context)),
            ]),
          ),
        ],
      ),
    );
  }
}
