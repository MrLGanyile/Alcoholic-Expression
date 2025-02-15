import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/competitions/competition.dart';
import '../models/competitions/won_price_summary.dart';

// Branch : competition_resources_crud ->  competitions_data_access
class CompetitionController extends GetxController {
  static CompetitionController competitionController = Get.find();

  // Branch : won_price_summary_resources_crud ->  won_price_summary_resources_data_access
  Stream<List<WonPriceSummary>> readAllWonPriceSummaries() =>
      FirebaseFirestore.instance
          .collection('won_prices_summaries')
          .snapshots()
          .map((wonPriceSummariesSnapshot) {
        List<WonPriceSummary> list =
            wonPriceSummariesSnapshot.docs.map((wonPriceSummaryDoc) {
          WonPriceSummary wonPriceSummary =
              WonPriceSummary.fromJson(wonPriceSummaryDoc.data());
          return wonPriceSummary;
        }).toList();
        list.sort();
        return list;
      });

  // Branch : competition_resources_crud ->  competitions_data_access
  Stream<DocumentSnapshot>? findCompetition(String competitionId) {
    return FirebaseFirestore.instance
        .collection('competitions')
        .doc(competitionId)
        .snapshots();
  }

  // Branch : competition_resources_crud ->  competitions_data_access
  // To Delete - Branches competitions_crud -> view_currently_playing_competition
  Future<Competition?> findFutureCompetition(String competitionId) async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('competitions')
        .doc(competitionId);

    reference.snapshots().map((referenceDoc) {
      return Competition.fromJson(referenceDoc.data());
    });

    return null;
  }

  // Branch : competition_resources_crud ->  competitions_data_access
  Stream<DocumentSnapshot<Object?>> retrieveCountDownClock(
      String countDownClockId) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('count_down_clocks')
        .doc(countDownClockId);

    return reference.snapshots();
  }
}
