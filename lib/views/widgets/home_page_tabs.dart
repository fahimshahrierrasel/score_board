import 'package:flutter/material.dart';
import 'package:score_board/views/widgets/match_list.dart';

const numberOfHomePageTabs = 2;

class HomePageTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: numberOfHomePageTabs,
      child: Scaffold(
        appBar: new TabBar(
          tabs: [
            Tab(
              text: "Current".toUpperCase(),
            ),
            Tab(
              text: "Previous".toUpperCase(),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            MatchList(
              matchStatus: MatchStatus.CURRENT,
            ),
            MatchList(
              matchStatus: MatchStatus.PREVIOUS,
            ),
          ],
        ),
      ),
    );
  }
}
