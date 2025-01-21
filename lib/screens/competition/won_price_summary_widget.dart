import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

import '../../models/Utilities/converter.dart';
import '../../models/competitions/won_price_summary.dart';
import 'dart:developer' as debug;
import 'dart:math';

// won_prices_crud -> create_won_price
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
                'Store Home',
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
                'Store Area',
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

  Widget retrieveCommentTextField(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return TextField(
      maxLines: 10,
      style: TextStyle(color: MyApplication.scaffoldBodyColor),
      cursorColor: MyApplication.scaffoldBodyColor,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Write Your Comment',
        helperMaxLines: 10,
        prefixIcon: Icon(Icons.comment, color: MyApplication.logoColor1),
        suffixIcon: GestureDetector(
          child: Icon(Icons.send, color: MyApplication.logoColor1),
          onTap: () {
            // Save Comment
          },
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          color: MyApplication.logoColor2,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: MyApplication.logoColor2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: MyApplication.logoColor2,
          ),
        ),
      ),
      obscureText: false,
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
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child:
                SizedBox(height: 40, child: retrieveCommentTextField(context)),
          ),
        ],
      ),
    );
  }
}
