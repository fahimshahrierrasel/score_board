import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:score_board/views/widgets/batsman_list_item.dart';
import 'package:score_board/views/widgets/bowler_list_item.dart';

class ScoreCard extends StatefulWidget {
  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ExpandablePanel(
              theme:
                  ExpandableThemeData(tapHeaderToExpand: true, hasIcon: false),
              header: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Team A Innings",
                        style: TextStyle(color: Colors.white)),
                    Text("154/5(14.4 Overs)",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  BatsmanListItem(
                    isHeader: true,
                    whiteHeader: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "c Rasel b Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "b Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "c & b Rasel",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "rout Shahrier",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "stmp Shahrier",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "b Rasel",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "lbw Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    onStrike: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    onStrike: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 0,
                    ballFaced: 0,
                    fours: 0,
                    sixes: 0,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 0,
                    ballFaced: 0,
                    fours: 0,
                    sixes: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Extras:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "3 (B 0, LB 2, W 1, NB 0)",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  BowlerListItem(
                    isHeader: true,
                    whiteHeader: true,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ExpandablePanel(
              theme:
              ExpandableThemeData(tapHeaderToExpand: true, hasIcon: false),
              header: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Team B Innings",
                        style: TextStyle(color: Colors.white)),
                    Text("160/6(16 Overs)",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  BatsmanListItem(
                    isHeader: true,
                    whiteHeader: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "c Rasel b Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "b Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "c & b Rasel",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "rout Shahrier",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "stmp Shahrier",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "b Rasel",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    outDetails: "lbw Fahim",
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    onStrike: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 34,
                    ballFaced: 22,
                    fours: 3,
                    sixes: 1,
                    onStrike: true,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 0,
                    ballFaced: 0,
                    fours: 0,
                    sixes: 0,
                  ),
                  BatsmanListItem(
                    name: "Fahim",
                    runs: 0,
                    ballFaced: 0,
                    fours: 0,
                    sixes: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Extras:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "3 (B 0, LB 2, W 1, NB 0)",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  BowlerListItem(
                    isHeader: true,
                    whiteHeader: true,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                  BowlerListItem(
                    name: "Rasel",
                    balls: 30,
                    runs: 25,
                    maidens: 0,
                    wickets: 1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
