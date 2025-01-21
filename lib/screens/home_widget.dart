import '/controllers/competition_controller.dart';

import '../models/competitions/won_price_summary.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'competition/won_price_summary_widget.dart';

import 'dart:developer' as debug;
import 'package:get/get.dart';

// won_prices_crud -> read_won_prices
class HomeWidget extends StatefulWidget {
  HomeWidget({
    super.key,
  });

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  CompetitionController competitionController =
      CompetitionController.competitionController;
  late Stream<List<WonPriceSummary>> wonPriceSummariesStream;
  _HomeWidgetState();

  @override
  void initState() {
    super.initState();
    wonPriceSummariesStream = competitionController.readAllWonPriceSummaries();
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
        child: StreamBuilder<List<WonPriceSummary>>(
          stream: wonPriceSummariesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<WonPriceSummary> wonPrices = snapshot.data!;
              return ListView.builder(
                itemCount: wonPrices.length,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      WonPriceSummaryWidget(wonPriceSummary: wonPrices[index]),
                    ],
                  );
                }),
              );
            } else if (snapshot.hasError) {
              debug.log(
                  "Error Fetching Won Price Summaries Data *** - ${snapshot.error}");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
}
