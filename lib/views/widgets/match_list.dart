import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/match_list_viewmodel.dart';
import 'package:score_board/views/widgets/current_match_card.dart';
import 'package:score_board/views/widgets/previous_match_card.dart';

class MatchList extends StatelessWidget {
  final MatchStatus matchStatus;

  const MatchList({Key key, this.matchStatus}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchListViewModel>(
      builder: (_, matchListViewModel, __){
        return FutureBuilder<List<Match>>(
          future: matchListViewModel.getMatchList(matchStatus),
          builder: (_context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  if(matchStatus == MatchStatus.CURRENT) {
                    return CurrentMatchCard(
                      match: snapshot.data[index],
                    );
                  }else{
                    return PreviousMatchCard(
                    );
                  }
                },
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
