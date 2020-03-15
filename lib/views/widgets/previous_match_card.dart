import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/viewmodels/match_list_viewmodel.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/helpers/extensions.dart';

class PreviousMatchCard extends StatelessWidget {
  final Match match;

  const PreviousMatchCard({Key key, this.match}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final matchListViewModel = Provider.of<MatchListViewModel>(context);
    final firstTeam = matchListViewModel.teams
        .firstWhere((team) => team.id == match.teams.teamOneId);
    final secondTeam = matchListViewModel.teams
        .firstWhere((team) => team.id == match.teams.teamTwoId);
    final winningTeam =
        match.result.winningTeam == firstTeam.id ? firstTeam : secondTeam;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: generalCardDecoration,
      child: FutureProvider<List<Innings>>(
        create: (_) => matchListViewModel.getMatchInningsBy(match.id),
        child: Consumer<List<Innings>>(
          builder: (_, innings, __) {
            if (innings != null && innings.length > 1) {
              final firstTeamInnings = innings.firstWhere(
                  (innings) => innings.battingTeamId == firstTeam.id);
              final secondTeamInnings = innings.firstWhere(
                  (innings) => innings.battingTeamId == secondTeam.id);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        firstTeam.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${firstTeamInnings.inningsStatus.totalRun}/${firstTeamInnings.inningsStatus.totalWicket}",
                            style: GoogleFonts.oswald(fontSize: 12),
                          ),
                          Text(
                            "(${firstTeamInnings.inningsStatus.totalBall.getOver()}/${match.configuration.totalOvers} Overs)",
                            style: GoogleFonts.oswald(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        secondTeam.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${secondTeamInnings.inningsStatus.totalRun}/${secondTeamInnings.inningsStatus.totalWicket}",
                            style: GoogleFonts.oswald(fontSize: 12),
                          ),
                          Text(
                            "(${secondTeamInnings.inningsStatus.totalBall.getOver()}/${match.configuration.totalOvers} Overs)",
                            style: GoogleFonts.oswald(fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        "${winningTeam.name} won by ${match.result.winBy}"),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
