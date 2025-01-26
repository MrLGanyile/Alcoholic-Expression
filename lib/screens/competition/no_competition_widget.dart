import 'package:flutter/material.dart';

import 'dart:developer' as debug;

import '../store/store_info_widget.dart';

// Branch : competition_resources_crud ->  view_competitions
class NoCompetitionWidget extends StoreInfoWidget {
  NoCompetitionWidget({
    super.key,
    required storeId,
    required storeName,
    required storeImageURL,
    required sectionName,
  }) : super(
          storeId: storeId,
          storeName: storeName,
          storeImageURL: storeImageURL,
          sectionName: sectionName,
        );

  @override
  State createState() => NoCompetitionWidgetState();
}

class NoCompetitionWidgetState extends State<NoCompetitionWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'No Competition',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink),
    ));
    ;
  }
}
