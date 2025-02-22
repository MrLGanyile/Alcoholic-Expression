import 'package:alco/controllers/competition_controller.dart';
import 'package:alco/controllers/group_controller.dart';
import 'package:alco/models/users/won_price_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/share_dao_functions.dart';
import '../../main.dart';
import '../users/alcoholic_registration_widget.dart';
import 'won_price_comment_widget.dart';

import 'dart:developer' as debug;

class WonPriceSummaryCommentsWidgets extends StatelessWidget {
  String wonPriceSummaryFK;
  final CompetitionController competitionController =
      CompetitionController.competitionController;
  final GroupController groupController = GroupController.instance;
  late List<WonPriceComment> comments;

  WonPriceSummaryCommentsWidgets({
    Key? key,
    required this.wonPriceSummaryFK,
  }) : super(key: key);

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
            if (currentlyLoggedInUser == null) {
              Get.to(() => const AlcoholicRegistrationWidget());
            } else {
              competitionController.saveWonPriceComment(
                  wonPriceSummaryFK, controller.text);
              controller.clear();
            }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Comments',
            style: TextStyle(
                fontSize: MyApplication.infoTextFontSize,
                color: MyApplication.attractiveColor1)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          color: MyApplication.logoColor2,
          onPressed: (() {
            Get.back();
          }),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<List<WonPriceComment>>(
          stream: competitionController.readWonPriceComments(wonPriceSummaryFK),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              comments = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: ((context, index) => WonPriceCommentWidget(
                            wonPriceComment: comments[index]))),
                  ),
                  Container(
                    height: 60,
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                        height: 55, child: retrieveCommentTextField(context)),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              debug.log('Error: ${snapshot.error.toString()} ');
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
  }
}
