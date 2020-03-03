import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/db_models/match.dart';
import 'package:score_board/viewmodels/match_list_viewmodel.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/commons/fade_page_route.dart';
import 'package:score_board/views/screens/current_match_page.dart';

class CurrentMatchCard extends StatelessWidget {
  final isMatchRunning;
  final Match match;

  const CurrentMatchCard({Key key, this.isMatchRunning = false, this.match})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final matchListViewModel = Provider.of<MatchListViewModel>(context);
    final firstTeam = matchListViewModel.teams
        .firstWhere((team) => team.id == match.teams.teamOneId);
    final secondTeam = matchListViewModel.teams
        .firstWhere((team) => team.id == match.teams.teamTwoId);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: generalCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              FadePageRoute(
                builder: (context) => CurrentMatchPage(
                  match: match,
                  firstTeam: firstTeam,
                  secondTeam: secondTeam,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          firstTeam.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isMatchRunning
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          secondTeam.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${match.configuration.playersPerTeam} Players on Each Team",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Total ${match.configuration.totalOvers} Overs",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
