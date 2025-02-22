import 'package:alco/controllers/group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/competitions/competition.dart';
import '../models/competitions/won_price_summary.dart';
import '../models/users/alcoholic.dart';
import '../models/users/won_price_comment.dart';

import 'dart:developer' as debug;

import 'share_dao_functions.dart';

// Branch : competition_resources_crud ->  competitions_data_access
class CompetitionController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instance;
  final storage = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  final auth = FirebaseAuth.instance;

  static CompetitionController competitionController = Get.find();
  GroupController groupController = GroupController.instance;

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

  Stream<List<WonPriceComment>> readWonPriceComments(
          String wonPriceSummaryFK) =>
      firestore
          .collection('won_prices_summaries')
          .doc(wonPriceSummaryFK)
          .collection('comments')
          .snapshots()
          .map((commentsSnapshot) {
        List<WonPriceComment> list = commentsSnapshot.docs.map((commentDoc) {
          WonPriceComment comment = WonPriceComment.fromJson(commentDoc.data());
          return comment;
        }).toList();
        list.sort();
        return list;
      });

  Future<void> saveFakeWonPriceComments() async {
    List<WonPriceComment> comments;

    DocumentReference reference;

    Stream<QuerySnapshot<Map<String, dynamic>>> collectionReference =
        firestore.collection('won_prices_summaries').snapshots();

    collectionReference.forEach((wonPriceSummariesSnapshot) async {
      wonPriceSummariesSnapshot.docs.forEach((wonPriceSummaryDoc) {
        wonPriceSummaryDoc.data();
        firestore
            .collection('won_prices_summaries')
            .doc(wonPriceSummaryDoc.id)
            .collection('comments')
            .snapshots()
            .forEach((commentsSnapshot) async {
          // Avoid Repeatedly Saving Same Comments
          if (commentsSnapshot.size == 0) {
            debug.log('about to add comments...');
            comments = [
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  dateCreated: DateTime(2024, 3, 1, 9, 38),
                  imageURL: 'alcoholics/profile_images/0634466388',
                  username: 'Mountain Mkhize Mhlongo',
                  message:
                      'Igijima Emaweni, Ayilali Nhlobo, Ayilambi Nhlobo, Ayikhathali Nhlobo, Inhliziyo Inhlabelela Ubusuku Nemini'),
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  imageURL: 'alcoholics/profile_images/0654566788',
                  username: 'Yebo',
                  dateCreated: DateTime(2025, 2, 13, 5, 13),
                  message:
                      'Nomangabe Kuyashisa Iyahlanelela, Nomangabe Kuyabanga Iyahlabelela, Nomangabe Liyaduma Lishaya Umbani Oshayisa Ngovalo Yona Ayimi Nhlobo Iyahlabelela. '),
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  imageURL: 'alcoholics/profile_images/0674847343',
                  username: 'Mountain Mkhize Mhlongo',
                  dateCreated: DateTime(2025, 2, 13, 23, 35),
                  message: 'Iyazi Ibhekephi Futhi Ngeke Ivinjwe Lutho'),
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  dateCreated: DateTime(2025, 1, 31, 20, 12),
                  imageURL: 'alcoholics/profile_images/0723343456',
                  username: 'Yebo',
                  message: 'Uloyo'),
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  dateCreated: DateTime(2024, 11, 13, 12, 0),
                  imageURL: 'alcoholics/profile_images/0723455444',
                  username: 'Zwe Captain',
                  message: 'Naloyo Ophuma Umphefumulo Into Yokuqala Ayisho '),
              WonPriceComment(
                  wonPriceSummaryFK: wonPriceSummaryDoc.id,
                  dateCreated: DateTime(2025, 2, 16, 23, 44),
                  imageURL: 'alcoholics/profile_images/0723664774',
                  username: 'Snathi',
                  message:
                      'Uma Efika Emazulwini Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo. Oyazi Isencane Isakhula Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo, Oyazi Isikhulile Isizazi Ukuthi Ingubani Izokwenzani Kulomhlaba Naye Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo, Ongakaze Ayibona Nhlobo Oyizizwa Ngendaba Naye Ucula Iculo Elifanayo Nami Ngiyavuma Akekho Ongaphezulu Kwayo.'),
            ];
            for (var commentIndex = 0;
                commentIndex < comments.length;
                commentIndex++) {
              reference = firestore
                  .collection('won_prices_summaries')
                  .doc(wonPriceSummaryDoc.id)
                  .collection('comments')
                  .doc();
              comments[commentIndex].setWonPriceCommentId(reference.id);
              await reference.set(comments[commentIndex].toJson());
            }
            debug.log('saveFakeWonPriceComments() saved comments');
          }
        });
      });
      wonPriceSummariesSnapshot.docs.map((wonPriceSummaryDoc) async {});
    });
  }

  Future<void> saveWonPriceComment(
    String wonPriceSummaryFK,
    String message,
  ) async {
    if (currentlyLoggedInUser == null) {
      return;
    }

    DocumentReference reference = firestore
        .collection('won_prices_summaries')
        .doc(wonPriceSummaryFK)
        .collection('comments')
        .doc();

    WonPriceComment comment = WonPriceComment(
        wonPriceCommentId: reference.id,
        wonPriceSummaryFK: wonPriceSummaryFK,
        message: message,
        imageURL: currentlyLoggedInUser!.profileImageURL,
        username: currentlyLoggedInUser! is Alcoholic
            ? (currentlyLoggedInUser! as Alcoholic).username
            : 'Admin');

    await reference.set(comment.toJson());
  }
}
