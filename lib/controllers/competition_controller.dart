import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/competitions/competition.dart';
import '../models/competitions/won_price_summary.dart';

// Branch : competitions_data_access
class CompetitionController extends GetxController {
  static CompetitionController competitionController = Get.find();

  Stream<List<WonPriceSummary>> readAllWonPriceSummaries() =>
      FirebaseFirestore.instance
          .collection('won_prices_summaries')
          .snapshots()
          .map((wonPriceSummariesSnapshot) =>
              wonPriceSummariesSnapshot.docs.map((wonPriceSummaryDoc) {
                WonPriceSummary wonPriceSummary =
                    WonPriceSummary.fromJson(wonPriceSummaryDoc.data());
                return wonPriceSummary;
              }).toList());

  Stream<DocumentSnapshot>? findCompetition(String competitionId) {
    return FirebaseFirestore.instance
        .collection('competitions')
        .doc(competitionId)
        .snapshots();
  }

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

  Stream<DocumentSnapshot<Object?>> retrieveCountDownClock(
      String countDownClockId) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('count_down_clocks')
        .doc(countDownClockId);

    return reference.snapshots();
  }
}
