import '/controllers/competition_controller.dart';
import '/screens/competition/group_competitor_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as debug;

import '../../../controllers/store_controller.dart';
import '../../../main.dart';
import '../../../models/stores/store_draw.dart';
import '../../models/stores/draw_grand_price.dart';
import 'grand_price_widget.dart';

typedef OnCurrentlyViewedUpdate = Function(bool);

typedef OnCurrentGroupSet = Function(GroupCompetitorWidget);

// store_draws_crud -> view_store_draws
class WaitWidget extends StatefulWidget {
  StoreDraw storeDraw;

  bool? showPlayIcon;
  bool showRemainingTime;
  bool showAlarm;

  Duration? remainingDuration;
  OnCurrentlyViewedUpdate? onCurrentlyViewedUpdate;

  List<int>? grandPricesOrder;
  bool? pickWonPrice;

  // Not used yet, but will be later to avoid flickuring of group members images.
  OnCurrentGroupSet? onCurrentGroupSet;

  int? groupPickingStartTime;

  WaitWidget(
      {Key? key,
      this.groupPickingStartTime,
      required this.storeDraw,
      this.remainingDuration,
      this.onCurrentlyViewedUpdate,
      this.showPlayIcon = false,
      this.pickWonPrice = false,
      this.showRemainingTime = false,
      this.showAlarm = true,
      this.grandPricesOrder = const [],
      this.onCurrentGroupSet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaitWidgetState();
}

class WaitWidgetState extends State<WaitWidget> {
  StoreController storeController = StoreController.storeController;
  CompetitionController competitionController =
      CompetitionController.competitionController;
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  late Stream<List<DrawGrandPrice>> drawGrandPricesStream;
  late List<DrawGrandPrice> drawGrandPrices;
  List<GrandPriceWidget> grandPricesWidgets = [];
  int currentlyPointedGrandPriceIndex = -1;

  @override
  void initState() {
    super.initState();
    drawGrandPricesStream = storeController.findDrawGrandPrices(
        widget.storeDraw.storeFK, widget.storeDraw.storeDrawId);
  }

  Widget remainingTime(int minutes, int seconds) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Remaining Time ',
              style: TextStyle(
                  fontSize: MyApplication.infoTextFontSize,
                  color: MyApplication.storesSpecialTextColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
            Text(
              '$minutes:$seconds',
              style: TextStyle(
                  fontSize: MyApplication.infoTextFontSize,
                  color: MyApplication.storesSpecialTextColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ],
        ));
  }

  Future<String> retrieveGrandPriceImageURL(String grandPriceImageURL) {
    return storageReference.child(grandPriceImageURL).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    int? minutes;
    int? seconds;

    if (widget.showRemainingTime) {
      int initialDuration = widget.remainingDuration!.inSeconds;

      minutes = initialDuration ~/ 60;
      seconds = initialDuration % 60;
    }

    // Sometimes the returned snapshot has empty data.
    return displayGrandPrices(minutes, seconds);
  }

  Widget displayGrandPrices(minutes, seconds) => StreamBuilder(
        stream: drawGrandPricesStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            drawGrandPrices = snapshot.data as List<DrawGrandPrice>;

            return Column(
              children: [
                (widget.showRemainingTime)
                    ? remainingTime(minutes!, seconds!)
                    : const SizedBox.shrink(),
                _buildGrandPrices(),
              ],
            );
          } else if (snapshot.hasError) {
            debug.log(
                'Error Fetching All Draw Grand Prices Data - ${snapshot.error}');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      );

  void addGrandPricesWidgets() {
    for (int i = 0; i < drawGrandPrices.length; i++) {
      grandPricesWidgets.add(GrandPriceWidget(
          showBall: widget.pickWonPrice!,
          isPointed: false,
          grandPriceImageURL: drawGrandPrices[i].imageURL));
    }
  }

  Widget _buildGrandPrices() {
    Widget grid;

    double horizontalGrandPriceSpaceces = 10;

    if (drawGrandPrices.isEmpty) {
      return const Center(
        child: Text("No Grand Prices Available"),
      );
    }

    if (grandPricesWidgets.isEmpty) {
      addGrandPricesWidgets();
    }

    int currentIndex = -1;
    if (widget.grandPricesOrder!.isNotEmpty) {
      currentIndex =
          widget.remainingDuration!.inSeconds % widget.grandPricesOrder!.length;
      currentlyPointedGrandPriceIndex = widget.grandPricesOrder![currentIndex];
    }

    switch (drawGrandPrices.length) {
      case 4:
        grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Left Grand Price.
                  retrieveStack(0),
                  const Expanded(child: SizedBox.shrink()),
                  // Top Right Grand Price.
                  retrieveStack(1),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [showAppropriateIcon()],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Grand Price.
                  retrieveStack(2),
                  const Expanded(child: SizedBox.shrink()),
                  // Bottom Right Grand Price.
                  retrieveStack(3),
                ],
              ),
            ),
          ],
        );
        break;
      case 5:
        grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Left Grand Price.
                  retrieveStack(0),
                  showAppropriateIcon(),
                  // Top Right Grand Price.
                  retrieveStack(1),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox.shrink()),
                // Middle Grand Price.
                retrieveStack(2),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Grand Price.
                  retrieveStack(3),
                  const Expanded(child: SizedBox.shrink()),
                  // Bottom Right Grand Price.
                  retrieveStack(4),
                ],
              ),
            ),
          ],
        );
        break;
      case 6:
        grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Left Grand Price.
                  retrieveStack(0),
                  showAppropriateIcon(),
                  // Top Right Grand Price.
                  retrieveStack(1),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Middle Left Grand Price.
                retrieveStack(2),
                const Expanded(child: SizedBox.shrink()),
                // Middle Right Grand Price.
                retrieveStack(3),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Grand Price.
                  retrieveStack(4),
                  const Expanded(child: SizedBox.shrink()),
                  // Bottom Right Grand Price.
                  retrieveStack(5),
                ],
              ),
            ),
          ],
        );
        break;
      case 7:
        grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Left Grand Price.
                  retrieveStack(0),
                  showAppropriateIcon(),
                  // Top Right Grand Price.
                  retrieveStack(1),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Middle Left Grand Price.
                retrieveStack(2),
                // Middle Right Grand Price.
                retrieveStack(3),
                // Middle Grand Price.
                retrieveStack(4),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Grand Price.
                  retrieveStack(5),
                  const Expanded(child: SizedBox.shrink()),
                  // Bottom Right Grand Price.
                  retrieveStack(6),
                ],
              ),
            ),
          ],
        );
        break;
      default:
        grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Left Grand Price.
                  retrieveStack(0),
                  // Top Middle Grand Price.
                  retrieveStack(1),
                  // Top Right Grand Price.
                  retrieveStack(2),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Middle Right Grand Price.
                retrieveStack(3),
                showAppropriateIcon(),
                // Middle Left Grand Price.
                retrieveStack(4),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: horizontalGrandPriceSpaceces,
                  bottom: horizontalGrandPriceSpaceces),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Grand Price.
                  retrieveStack(5),
                  // Middle Bottom Grand Price.
                  retrieveStack(6),
                  // Bottom Right Grand Price.
                  retrieveStack(7),
                ],
              ),
            ),
          ],
        );
    }

    return grid;
  }

  Stack retrieveStack(int grandPriceIndex) {
    return Stack(
      children: [
        grandPricesWidgets[grandPriceIndex],
        grandPriceIndex == currentlyPointedGrandPriceIndex
            ? Center(
                child: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApplication.attractiveColor2,
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget showAppropriateIcon() {
    if (widget.showAlarm) {
      return buildAlarm();
    } else if (widget.showRemainingTime || widget.pickWonPrice!) {
      return const Expanded(child: SizedBox.shrink());
    } else {
      return buildPlayIcon();
    }
  }

  Widget buildPlayIcon() => Expanded(
        child: SizedBox(
          height: MyApplication.alarmIconFontSize,
          width: MyApplication.alarmIconFontSize,
          child: !widget.showPlayIcon!
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    // Add Alarm So That A User Will Be Informed When The Draw/Competition Begins.
                    debug.log('play button pressed...');
                    widget.onCurrentlyViewedUpdate!(true);
                  },
                  icon: Icon(
                    Icons.play_circle,
                    color: MyApplication.logoColor1,
                    size: MyApplication.alarmIconFontSize,
                  ),
                ),
        ),
      );

  Widget buildAlarm() => // Alarm
      Expanded(
        child: SizedBox(
          height: MyApplication.alarmIconFontSize,
          width: MyApplication.alarmIconFontSize,
          child: IconButton(
            onPressed: () => {
              // Add Alarm So That A User Will Be Informed When The Draw/Competition Begins.
              debug.log('Alarm Will Go On At ...')
            },
            icon: Icon(
              Icons.add_alarm,
              color: MyApplication.storesTextColor,
              size: MyApplication.alarmIconFontSize,
            ),
          ),
        ),
      );
}
