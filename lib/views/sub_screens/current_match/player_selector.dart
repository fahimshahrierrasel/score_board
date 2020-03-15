import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/views/commons/decorations.dart';

class PlayerSelector extends StatelessWidget {
  final int teamId;
  final List<int> disabledPlayers;

  PlayerSelector({
    Key key,
    this.teamId,
    this.disabledPlayers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentMatchViewModel = Provider.of<CurrentMatchViewModel>(context);
    final team = currentMatchViewModel.firstTeam.id == teamId
        ? currentMatchViewModel.firstTeam
        : currentMatchViewModel.secondTeam;

    final playersId = currentMatchViewModel.firstTeam.id == teamId
        ? currentMatchViewModel.currentMatch.players.teamOnePlayers
        : currentMatchViewModel.currentMatch.players.teamTwoPlayers;

    final players = currentMatchViewModel.players
        .where((player) => playersId.contains(player.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.name} Players"),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: generalCardDecoration,
            child: ListTile(
              enabled: !disabledPlayers.contains(players[index].id),
              title: Text(
                "${players[index].firstName} ${players[index].lastName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(PLAYER_TYPE[players[index].type]),
              onTap: () {
                Navigator.pop(context, players[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
