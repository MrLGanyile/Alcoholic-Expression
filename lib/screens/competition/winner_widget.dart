import 'package:flutter/material.dart';

import '../../controllers/store_controller.dart';
import '../../main.dart';
import '../../models/stores/store.dart';
import '../../models/competitions/won_price_summary.dart';
import '../store/store_info_widget.dart';

// : Branch : won_price_summary_resources_crud -> view_won_price_summaries
class WinnerWidget extends StatefulWidget {
  final WonPriceSummary wonPriceSummary;
  final bool showStoreInfoFirst;

  const WinnerWidget({
    super.key,
    required this.wonPriceSummary,
    this.showStoreInfoFirst = false,
  });

  @override
  WinnerWidgetState createState() => WinnerWidgetState();
}

class WinnerWidgetState extends State<WinnerWidget> {
  StoreController storeController = StoreController.storeController;
  late Store store;

  @override
  void initState() {
    super.initState();

    store = storeController.findStore(widget.wonPriceSummary.storeFK) as Store;
  }

  bool isKnown = false;
  String groupValue = '1';

  void onKnownChanged(value) {
    setState(() {
      if (value == 'Yes') {
        isKnown = true;
      } else {
        isKnown = false;
      }
    });
  }

  // Ask If The Current User Knows The Winner.
  Widget ask() => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Text(
              'Do You Know Him/Her',
              style: TextStyle(
                fontSize: MyApplication.infoTextFontSize,
                color: MyApplication.storeInfoTextColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            Row(
              children: [
                Radio(
                    value: '1',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        //groupValue = value!;
                      });
                    }),
                Radio(
                    value: '2',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        //groupValue = value!;
                      });
                    }),
              ],
            ),
          ],
        ),
      );

  // The Image Of A Leder.
  Center winnerImage() => Center(
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width / 4,
          backgroundColor: Colors.orange,
          backgroundImage: NetworkImage(
            widget.wonPriceSummary.groupCreatorImageURL,
          ),
        ),
      );

  // Information About The Price Won.
  Column priceInfo(BuildContext context) {
    String wonPriceDescription = widget.wonPriceSummary.grandPriceDescription;
    Color wonPriceDescriptionColor = const Color.fromARGB(255, 244, 3, 184);

    double screenWidth = MediaQuery.of(context).size.width;
    int singleLineMaxNoOfCharacters = screenWidth ~/ 9;

    double containerHeight;

    if (wonPriceDescription.length > singleLineMaxNoOfCharacters) {
      containerHeight =
          18 * (wonPriceDescription.length / singleLineMaxNoOfCharacters);
    } else {
      containerHeight = 18;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The Details Of What Is Won.
        Center(
          child: SizedBox(
            height: containerHeight,
            child: Text(
              'Won Price [${widget.wonPriceSummary.grandPriceDescription}]',
              style: TextStyle(
                color: wonPriceDescriptionColor,
                fontSize: MyApplication.infoTextFontSize,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,

                //overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),

        // The Winning Date.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Winning Date',
              style: TextStyle(
                fontSize: MyApplication.infoTextFontSize,
                color: MyApplication.storeInfoTextColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              widget.wonPriceSummary.wonDate.toString().substring(0, 10),
              style: TextStyle(
                fontSize: MyApplication.infoTextFontSize,
                color: MyApplication.storeInfoTextColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // Information About The Hosting Store.
            StoreInfoWidget(
              storeId: store.storeOwnerPhoneNumber,
              storeName: store.storeName,
              storeImageURL: store.storeImageURL,
              sectionName: store.sectionName,
            ),
            ask(),
            winnerImage(),
            priceInfo(context),
          ],
        ),
      );

  onTap(BuildContext context) {}
}
