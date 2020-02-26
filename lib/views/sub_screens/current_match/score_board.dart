import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';

class ScoreBoard extends StatelessWidget {
  final CurrentMatchViewModel currentMatchViewModel;
  const ScoreBoard({
    Key key, this.currentMatchViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentMatchViewModel
                      .getTeamById(
                          currentMatchViewModel.currentInnings.battingTeamId)
                      .name,
                  style: GoogleFonts.oswald(fontSize: 36),
                ),
                Text(
                  "CRR: ${currentMatchViewModel.currentRunRate.toStringAsFixed(2)}",
                ),
                Text(
                  "RRR: ${currentMatchViewModel.requiredRunRate.toStringAsFixed(2)}",
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${currentMatchViewModel.totalRun}/${currentMatchViewModel.totalWicket}",
                  style: GoogleFonts.oswald(fontSize: 48),
                ),
                Text(
                  "${(currentMatchViewModel.totalBall / 6).floor()}${currentMatchViewModel.totalBall % 6 > 0 ? "." : ""}${currentMatchViewModel.totalBall % 6 > 0 ? (currentMatchViewModel.totalBall % 6) : ""} Overs",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            )
          ],
        ),
        ExpandableButton(
          child: Icon(Icons.expand_more),
        )
      ],
    );
  }
}
