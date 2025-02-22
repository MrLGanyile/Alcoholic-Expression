import 'package:alco/screens/competition/won_price_summary_comments_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/competition_controller.dart';
import '../../main.dart';

import '../../models/locations/converter.dart';
import '../../models/competitions/won_price_summary.dart';
import 'dart:developer' as debug;
import 'dart:math';

// Branch : won_price_summary_resources_crud -> view_won_price_summaries
class WonPriceSummaryWidget extends StatefulWidget {
  WonPriceSummary wonPriceSummary;
  WonPriceSummaryWidget({
    required this.wonPriceSummary,
  });

  @override
  State createState() => WonPriceSummaryWidgetState();
}

class WonPriceSummaryWidgetState extends State<WonPriceSummaryWidget> {
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  late List<Reference> groupMembersImageReferences;

  CompetitionController competitionController =
      CompetitionController.competitionController;

  WonPriceSummaryWidgetState();

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
                  widget.wonPriceSummary.groupName,
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
                  Converter.asString(widget.wonPriceSummary.groupSectionName),
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
                  widget.wonPriceSummary.groupSpecificLocation,
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

  Column retrieveStoreInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store section
        Row(
          children: [
            Expanded(
              child: Text(
                'Host Home',
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
                  Converter.asString(widget.wonPriceSummary.storeSection),
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
        // Store section
        Row(
          children: [
            Expanded(
              child: Text(
                'Host Area',
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
                  widget.wonPriceSummary.storeArea,
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
                  Converter.asString(widget.wonPriceSummary.groupSectionName),
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
                  widget.wonPriceSummary.groupSpecificLocation,
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

// ===================Won Price Display Start===================
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
                  widget.wonPriceSummary.grandPriceDescription,
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
                  widget.wonPriceSummary.wonDate.toString().substring(0, 16),
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
    return storageReference
        .child(widget.wonPriceSummary.wonGrandPriceImageURL)
        .getDownloadURL();
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
        .child(widget.wonPriceSummary.groupCreatorImageURL)
        .getDownloadURL();
  }

  // ===================Won Price Display Ends===================

  // ===================Group Members Display Start===================
  Future<ListResult> findGroupMembersImageURLs() async {
    return storageReference
        .child(
            'group_members/${widget.wonPriceSummary.groupCreatorPhoneNumber}')
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
                  color: Colors.lightBlue,
                ),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
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
              child: CircularProgressIndicator(),
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

    if (groupMembersImageReferences.length <= 3) {
      rowChildren = [];
      for (int i = 0; i < groupMembersImageReferences.length; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      return row;
    } else {
      columnChildren = [];
      rowChildren = [];
      for (int i = 0; i < 3; i++) {
        rowChildren.add(createGroupParticipant(context, i));
      }
      row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      );
      columnChildren.add(row);

      rowChildren = [];
      for (int i = 3; i < groupMembersImageReferences.length; i++) {
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
  // ===================Group Members Display End===================

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
              // Store Name
              SizedBox(
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.wonPriceSummary.storeName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyApplication.attractiveColor1,
                      decoration: TextDecoration.none,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Group Location/Area Details
              SizedBox(height: 40, child: retrieveStoreInfo(context)),
              const SizedBox(
                height: 5,
              ),
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
                                  widget.wonPriceSummary.groupCreatorUsername,
                                  style: TextStyle(
                                    color: MyApplication.logoColor2,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  widget.wonPriceSummary.groupName,
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

          Container(
            margin: const EdgeInsets.only(right: 15),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Get.to(() => WonPriceSummaryCommentsWidgets(
                      wonPriceSummaryFK:
                          widget.wonPriceSummary.wonPriceSummaryId));
                },
                icon: Icon(
                  Icons.message,
                  size: 30,
                  color: MyApplication.logoColor1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
