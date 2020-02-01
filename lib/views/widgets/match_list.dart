import 'package:flutter/material.dart';
import 'package:score_board/views/widgets/current_match_card.dart';
import 'package:score_board/views/widgets/previous_match_card.dart';

enum MatchStatus{
  CURRENT,
  PREVIOUS
}

class MatchList extends StatelessWidget {
  final MatchStatus matchStatus;

  const MatchList({Key key, this.matchStatus}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) {
        if(matchStatus == MatchStatus.CURRENT) {
          return CurrentMatchCard(
            isMatchRunning: index < 2,
          );
        }else{
          return PreviousMatchCard(
          );
        }
      },
    );
  }
}
