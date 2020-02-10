import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_board/views/sub_screens/current_match/match_control.dart';
import 'package:score_board/views/sub_screens/current_match/score_card.dart';

class CurrentMatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team A vs Team B"),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new TabBar(
            tabs: [
              Tab(
                text: "Cockpit".toUpperCase(),
              ),
              Tab(
                text: "ScoreCard".toUpperCase(),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              MatchControl(),
              ScoreCard(),
            ],
          ),
        ),
      ),
    );
  }
}
