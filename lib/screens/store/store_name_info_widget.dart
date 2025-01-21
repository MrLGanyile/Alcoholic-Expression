import '../../controllers/user_controller.dart';
import '/controllers/competition_controller.dart';
import '/screens/competition/competition_result_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../controllers/store_controller.dart';
import '../../models/competitions/competition.dart';
import '../../models/competitions/count_down_clock.dart';
import '../../models/users/group.dart';
import '../../models/stores/store_draw.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/Utilities/converter.dart';

import 'dart:developer' as debug;

import '../../models/stores/store_draw_state.dart';
import '../../models/stores/store_name_info.dart';
import '../competition/competition_finished_widget.dart';
import '../competition/group_competitor_widget.dart';
import '../competition/no_competition_widget.dart';
import '../competition/wait_widget.dart';

// initialization -> create_store
class StoreNameInfoWidget extends StatefulWidget {
  StoreNameInfo storeNameInfo;

  int wonPriceIndex = -1; // For Testing Purposes Only.
  String wonGroupLeaderPhoneNumber = "-"; // For Testing Purposes Only.

  StoreNameInfoWidget({
    super.key,
    required this.storeNameInfo,
  });

  @override
  State<StatefulWidget> createState() => StoreNameInfoWidgetState();
}

class StoreNameInfoWidgetState extends State<StoreNameInfoWidget> {
  StoreController storeController = StoreController.storeController;
  UserController userController = UserController.instance;
  late CompetitionController competitionController;
  late Stream<DocumentSnapshot> storeNameInfoSteam;
  late Reference storageReference;

  bool isCurrentlyViewed = false;

  late CountDownClock countDownClock;
  late DocumentReference competitionReference;
  late Competition competition;

  // =======================================================

  // Not used yet, but will be later to avoid flickuring of group members images.
  late Widget currentGroupCompetitorWidget;
  CompetitionResultWidget? competitionResultWidget;
  // =======================================================

  List<String>? competitorsOrder;
  bool? pickWonGroup;
  late Stream<List<Group>> groupsStream;
  late List<Group> groups;
  List<GroupCompetitorWidget> groupCompetitorsWidgets = [];

  // Not used yet, but will be later to avoid flickuring of group members images.
  OnCurrentGroupSet? onCurrentGroupSet;

  int currentlyPointedGroupCompetitorIndex = 0;

  @override
  void initState() {
    super.initState();
    competitionController = CompetitionController.competitionController;
    storeNameInfoSteam = storeController
        .retrieveStoreNameInfo(widget.storeNameInfo.storeNameInfoId);
    storageReference = FirebaseStorage.instance
        .refFromURL("gs://alcoholic-expressions.appspot.com/");
    groupsStream = userController.readGroups(widget.storeNameInfo.sectionName);
  }

  void updateIsCurrentlyViewed(bool isCurrentlyViewed) {
    setState(() {
      this.isCurrentlyViewed = isCurrentlyViewed;
    });
  }

  void updateCurrentGroupCompetitorWidget(
      GroupCompetitorWidget currentGroupCompetitorWidget) {
    this.currentGroupCompetitorWidget = currentGroupCompetitorWidget;
  }

  Column retrieveStoreDetails(BuildContext context) {
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
                    color: MyApplication.storesTextColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.storeNameInfo.storeName,
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

        // The Address Of A Store On Which The Winner Won From.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Store Area',
                style: TextStyle(
                    fontSize: MyApplication.infoTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: MyApplication.storesTextColor,
                    decoration: TextDecoration.none),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  Converter.asString(widget.storeNameInfo.sectionName),
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
      ],
    );
  }

  Future<String> retrieveStoreImageURL(String storeImageURL) {
    return storageReference.child(storeImageURL).getDownloadURL();
  }

  AspectRatio retrieveStoreImage(BuildContext context, String storeImageURL) {
    // The Image Of A Store On Which The Winner Won From.
    return AspectRatio(
      aspectRatio: 5 / 2,
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8) ,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(storeImageURL)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          // Store Image
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FutureBuilder(
                future:
                    retrieveStoreImageURL(widget.storeNameInfo.storeImageURL),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return retrieveStoreImage(context, snapshot.data as String);
                  } else if (snapshot.hasError) {
                    debug.log('Error Fetching Store Image - ${snapshot.error}');
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          // Store Details
          retrieveStoreDetails(context),
          myStoreState(),
        ],
      ),
    );
  }

  Widget myStoreState() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: StreamBuilder<DocumentSnapshot?>(
        stream: storeController.retrieveStoreDraw(
            widget.storeNameInfo.storeNameInfoId,
            widget.storeNameInfo.latestStoreDrawId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            StoreDraw latestStoreDraw = StoreDraw.fromJson(snapshot.data);
            DateTime latestPast =
                DateTime.now().subtract(const Duration(days: 1));

            if (latestStoreDraw.drawDateAndTime.isBefore(latestPast)) {
              debug.log("last store draw is before now");
              return NoCompetitionWidget(
                  storeId: widget.storeNameInfo.storeNameInfoId,
                  storeName: widget.storeNameInfo.storeName,
                  storeImageURL: widget.storeNameInfo.storeImageURL,
                  sectionName: widget.storeNameInfo.sectionName);
            } else if (latestStoreDraw.storeDrawState ==
                StoreDrawState.notConvertedToCompetition) {
              // The corresponding readonly document do not exist yet.
              return WaitWidget(
                storeDraw: latestStoreDraw,
              );
            } else {
              return StreamBuilder<DocumentSnapshot>(
                  stream: competitionController
                      .findCompetition(latestStoreDraw.storeDrawId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      competition = Competition.fromJson(snapshot.data);
                      int grandPricePickingDuration =
                          competition.grandPricesOrder.length *
                              competition.pickingMultipleInSeconds;
                      int groupPickingDuration =
                          competition.grandPricesOrder.length *
                                  competition.pickingMultipleInSeconds +
                              competition.competitorsOrder.length *
                                  competition.pickingMultipleInSeconds;
                      int competitionTotalDuration = grandPricePickingDuration +
                          competition.timeBetweenPricePickingAndGroupPicking! +
                          groupPickingDuration;

                      int day = latestStoreDraw.drawDateAndTime.day;
                      int month = latestStoreDraw.drawDateAndTime.month;
                      int year = latestStoreDraw.drawDateAndTime.year;
                      int hour = latestStoreDraw.drawDateAndTime.hour;
                      int minute = latestStoreDraw.drawDateAndTime.minute;

                      String collectionId = "$day-$month-$year-$hour-$minute";

                      competitionReference = snapshot.data!.reference;

                      return readFromcountDownClock(
                        collectionId,
                        latestStoreDraw,
                      );
                    } else if (snapshot.hasError) {
                      debug.log(
                          "Error Fetching competition Data - ${snapshot.error}");
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            }
          } else if (snapshot.hasError) {
            debug
                .log("Error Fetching Last Store Draw Data - ${snapshot.error}");
            return NoCompetitionWidget(
                storeId: widget.storeNameInfo.storeNameInfoId,
                storeName: widget.storeNameInfo.storeName,
                storeImageURL: widget.storeNameInfo.storeImageURL,
                sectionName: widget.storeNameInfo.sectionName);
          } else {
            return NoCompetitionWidget(
                storeId: widget.storeNameInfo.storeNameInfoId,
                storeName: widget.storeNameInfo.storeName,
                storeImageURL: widget.storeNameInfo.storeImageURL,
                sectionName: widget.storeNameInfo.sectionName);
          }
        },
      ),
    );
  }

  StreamBuilder<DocumentSnapshot> readFromcountDownClock(
    String coundDownClockId,
    StoreDraw latestStoreDraw,
  ) {
    return StreamBuilder<DocumentSnapshot>(
        stream: competitionController.retrieveCountDownClock(coundDownClockId),
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            countDownClock = CountDownClock.fromJson(snapshot.data);

            int grandPricePickingDuration =
                competition.grandPricesOrder.length *
                    competition.pickingMultipleInSeconds;
            int groupPickingDuration = competition.grandPricesOrder.length *
                    competition.pickingMultipleInSeconds +
                competition.competitorsOrder.length *
                    competition.pickingMultipleInSeconds;
            int competitionTotalDuration = grandPricePickingDuration +
                competition.timeBetweenPricePickingAndGroupPicking! +
                groupPickingDuration;

            DateTime competitionEndTime = competition.dateTime
                .add(Duration(seconds: competitionTotalDuration));

            if (countDownClock.remainingTime < 0) {
              // Show remaining time before competition starts.
              return WaitWidget(
                storeDraw: latestStoreDraw,
                remainingDuration:
                    Duration(seconds: countDownClock.remainingTime * -1),
                pickWonPrice: false,
                showPlayIcon: false,
                showAlarm: false,
                showRemainingTime: true,
                onCurrentlyViewedUpdate: updateIsCurrentlyViewed,
              );
            }
            // Show grand prices with play icon.
            else if (!isCurrentlyViewed &&
                countDownClock.remainingTime < competitionTotalDuration) {
              return WaitWidget(
                remainingDuration:
                    Duration(seconds: countDownClock.remainingTime),
                storeDraw: latestStoreDraw,
                pickWonPrice: false,
                showPlayIcon: true,
                showAlarm: false,
                showRemainingTime: false,
                grandPricesOrder: const [],
                onCurrentlyViewedUpdate: updateIsCurrentlyViewed,
              );
            }

            // Show and pick grand prices.
            else if (isCurrentlyViewed &&
                countDownClock.remainingTime < grandPricePickingDuration) {
              return WaitWidget(
                remainingDuration:
                    Duration(seconds: countDownClock.remainingTime),
                storeDraw: latestStoreDraw,
                pickWonPrice: true,
                showAlarm: false,
                grandPricesOrder: competition.grandPricesOrder,
              );
            }

            // Display won price.
            else if (isCurrentlyViewed &&
                countDownClock.remainingTime <
                    grandPricePickingDuration +
                        competition.timeBetweenPricePickingAndGroupPicking!) {
              return Center(
                child: Text(
                  "Won Price Display",
                  style: TextStyle(color: MyApplication.attractiveColor1),
                ),
              );
            }
            // Show group picking
            else if (isCurrentlyViewed &&
                countDownClock.remainingTime <= groupPickingDuration) {
              currentlyPointedGroupCompetitorIndex =
                  (countDownClock.remainingTime -
                          competition.groupPickingStartTime) ~/
                      competition.pickingMultipleInSeconds;
              debug.log(
                  '$currentlyPointedGroupCompetitorIndex ${competition.competitorsOrder.length}');
              return displayGroupCompetitors();
            }

            // Show Won Price Summary For The Next 5 Minute.
            else if (countDownClock.remainingTime <= competitionTotalDuration) {
              if (!competition.isWonCompetitorGroupPicked!) {
                competitionReference
                    .update({"isWonCompetitorGroupPicked": true});
              }
              if (!competition.isOver) {
                competitionReference.update({"isOver": true});

                // setWonPriceSummary(competition.competitionId!);
              }

              // State Management Glitch Exist Here.
              /*
              competitionResultWidget ??= CompetitionResultWidget(
                wonPrice: competition.wonPrice!,
                wonGroup: competition.wonGroup!,
                competitionEndTime: competitionEndTime,
              );
              
              return competitionResultWidget!; */
              return Center(
                child: Text(
                  'Show Won Price & Group',
                  style: TextStyle(color: MyApplication.attractiveColor1),
                ),
              );
            }

            // Show game over
            else {
              return CompetitionFinishedWidget(endMoment: competitionEndTime);
            }
          } else if (snapshot.hasError) {
            debug.log('Error fetching count down clock data ${snapshot.error}');
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

  // Assuming there is a cloud function returning a list of fruit in the backend.
  Future<void> getFruit() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('listFruit');
    final results = await callable();
    List fruit =
        results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  }

  Future<void> writeMessage(String message) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('writeMessage');
    final resp = await callable.call(<String, dynamic>{
      'text': 'A message sent from a client device',
    });
    print("result: ${resp.data}");
  }

  Future<void> setWonPriceSummary(String competitionId) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('createWonPriceSummary');
    await callable.call(<String, dynamic>{
      'competition': competitionId,
    });
  }

  Widget displayGroupCompetitors() {
    if (groupCompetitorsWidgets.isEmpty) {
      return StreamBuilder<List<Group>>(
        stream: groupsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            groups = snapshot.data!;
            addGroupCompetitorsWidgets();
            return groupCompetitorsWidgets[
                currentlyPointedGroupCompetitorIndex];
          } else if (snapshot.hasError) {
            debug.log(
                'Error Fetching Group Competitors Data - ${snapshot.error}');
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
    } else {
      return groupCompetitorsWidgets[currentlyPointedGroupCompetitorIndex];
    }
  }

  void addGroupCompetitorsWidgets() {
    if (groupCompetitorsWidgets.isEmpty) {
      for (int groupCompetitorIndex = 0;
          groupCompetitorIndex < competition.competitorsOrder.length;
          groupCompetitorIndex++) {
        for (int i = 0; i < groups.length; i++) {
          if (groups[i].groupCreatorPhoneNumber.compareTo(
                  competition.competitorsOrder[groupCompetitorIndex]) ==
              0) {
            groupCompetitorsWidgets
                .add(GroupCompetitorWidget(group: groups[i]));
          }
        }
      }
    }
  }
}
