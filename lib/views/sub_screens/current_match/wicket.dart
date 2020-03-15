import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/helpers/extensions.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class WicketDialog extends StatefulWidget {
  WicketDialog({Key key}) : super(key: key);

  @override
  _WicketDialogState createState() => _WicketDialogState();
}

class _WicketDialogState extends State<WicketDialog> {
  int _outType = 0;
  Player _assistPlayerId;
  int _batsmanId = 0;

  void outDecision() {
    final Map<String, dynamic> out = new Map();
    out[OUT_TYPE] = _outType;
    if (_assistPlayerId != null) out[ASSIST_ID] = _assistPlayerId.id;
    out[OUT_BATSMAN_ID] = _batsmanId;
    Navigator.of(context).pop(out);
  }

  @override
  Widget build(BuildContext context) {
    final currentMatchViewModel = Provider.of<CurrentMatchViewModel>(context);
    final fieldersId = currentMatchViewModel.currentInnings.bowlingTeamId ==
            currentMatchViewModel.firstTeam.id
        ? currentMatchViewModel.currentMatch.players.teamOnePlayers
        : currentMatchViewModel.currentMatch.players.teamTwoPlayers;

    final fielders = currentMatchViewModel.players
        .where((player) => fieldersId.contains(player.id))
        .toList();

    final firstBatsman = currentMatchViewModel.firstBatsmanBatting != null
        ? currentMatchViewModel
            .getPlayerById(currentMatchViewModel.firstBatsmanBatting.playerId)
        : Player();
    final secondBatsman = currentMatchViewModel.secondBatsmanBatting != null
        ? currentMatchViewModel
            .getPlayerById(currentMatchViewModel.secondBatsmanBatting.playerId)
        : Player();

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: OutType.values
                            .map(
                              (outType) => RadioWithTitle(
                                title: "${outType.value}",
                                value: outType.index,
                                groupValue: _outType,
                                onChange: (num) {
                                  setState(() {
                                    _outType = num;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (OutType.CAUGHT.index == _outType)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Caught By",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            DropdownButton<Player>(
                              isExpanded: true,
                              value: _assistPlayerId,
                              items: fielders
                                  .map(
                                    (player) => DropdownMenuItem<Player>(
                                      child: Text(
                                          "${player.firstName} ${player.lastName}"),
                                      value: player,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (updatedItem) {
                                setState(() {
                                  _assistPlayerId = updatedItem;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    if (OutType.RUN.index == _outType)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Which batsman is out",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Wrap(
                              children: <Widget>[
                                RadioWithTitle(
                                  value: 0,
                                  title:
                                      "${firstBatsman.firstName} ${firstBatsman.lastName}",
                                  groupValue: _batsmanId,
                                  onChange: (newOutPlayer) {
                                    setState(() {
                                      _batsmanId = newOutPlayer;
                                    });
                                  },
                                ),
                                RadioWithTitle(
                                  value: 1,
                                  title:
                                      "${secondBatsman.firstName} ${secondBatsman.lastName}",
                                  groupValue: _batsmanId,
                                  onChange: (newOutPlayer) {
                                    setState(() {
                                      _batsmanId = newOutPlayer;
                                    });
                                  },
                                )
                              ],
                            ),
                            Text(
                              "Run out by",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            DropdownButton<Player>(
                              isExpanded: true,
                              value: _assistPlayerId,
                              items: fielders
                                  .map(
                                    (player) => DropdownMenuItem<Player>(
                                      child: Text(
                                          "${player.firstName} ${player.lastName}"),
                                      value: player,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (updatedItem) {
                                setState(() {
                                  _assistPlayerId = updatedItem;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              FlatRoundedButton(title: "Out", onPress: outDecision)
            ]),
      ),
    );
  }
}

class RadioWithTitle extends StatelessWidget {
  final int value;
  final String title;
  final int groupValue;
  final Function onChange;

  const RadioWithTitle(
      {Key key, this.value, this.title, this.groupValue, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio<int>(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
