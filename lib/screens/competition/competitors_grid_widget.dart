import 'package:flutter/material.dart';

// competitions_crud -> view_currently_playing_competition
class CompetitorsGridWidget extends StatefulWidget {
  String competitionId;
  int passedTime;

  CompetitorsGridWidget({
    required this.competitionId,
    required this.passedTime,
  });

  @override
  State createState() => CompetitorsGridWidgetState();
}

class CompetitorsGridWidgetState extends State<CompetitorsGridWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Competitors Grid',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink),
    ));
    ;
  }
}
