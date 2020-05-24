import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/helpers/extensions.dart';

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentMatchViewModel = Provider.of<CurrentMatchViewModel>(context);
    final team = currentMatchViewModel
        .getTeamById(currentMatchViewModel.currentInnings.battingTeamId);

    int runNeeded = 0;
    String remainingBall = "";
    double requiredRunRate = 0.0;
    if (currentMatchViewModel.currentInnings.number == 2) {
      runNeeded =
          (currentMatchViewModel.matchInnings[0].inningsStatus.totalRun -
                  currentMatchViewModel.currentInnings.inningsStatus.totalRun) +
              1;
      int ballLeft =
          currentMatchViewModel.currentMatch.configuration.totalOvers * 6 -
              currentMatchViewModel.currentInnings.inningsStatus.totalBall;
      if (ballLeft < 100) {
        remainingBall = "$ballLeft Balls.";
      } else {
        remainingBall = ballLeft.getOver();
      }

      final overs = ballLeft / 6.0;
      requiredRunRate = runNeeded / overs;
    }

    final currentRunRate = currentMatchViewModel.calculateRunRates(
        currentMatchViewModel.currentInnings.inningsStatus.totalRun,
        currentMatchViewModel.currentInnings.inningsStatus.totalBall);

    return Column(
      children: <Widget>[
        if (currentMatchViewModel.currentInnings.number == 2)
          Text("${team.name} need $runNeeded run in $remainingBall"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  team.name,
                  style: GoogleFonts.oswald(fontSize: 36),
                ),
                Text(
                  "CRR: ${currentRunRate.toStringAsFixed(2)}",
                ),
                Text(
                  "RRR: ${requiredRunRate.toStringAsFixed(2)}",
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${currentMatchViewModel.currentInnings.inningsStatus.totalRun}/${currentMatchViewModel.currentInnings.inningsStatus.totalWicket}",
                  style: GoogleFonts.oswald(fontSize: 48),
                ),
                Text(
                  "${currentMatchViewModel.currentInnings.inningsStatus.totalBall.getOver()}",
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
