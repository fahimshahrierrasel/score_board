import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/viewmodels/view_state.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class Summery extends StatelessWidget {
  final Function onConfirmPress;

  const Summery({Key key, @required this.onConfirmPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new TabBar(
          tabs: [
            Tab(
              text: "Details".toUpperCase(),
            ),
            Tab(
              text: configViewModel.firstTeamName.toUpperCase(),
            ),
            Tab(
              text: configViewModel.secondTeamName.toUpperCase(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  MatchDetails(),
                  PlayerList(
                    teamNo: TeamNo.FIRST,
                  ),
                  PlayerList(
                    teamNo: TeamNo.SECOND,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatRoundedButton(
                loading: configViewModel.state == ViewState.Busy,
                title: "Confirm",
                onPress: () {
                  configViewModel.saveMatchConfig().then((value) {
                    if (value) onConfirmPress();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MatchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            configViewModel.firstTeamName,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("VS"),
          ),
          Text(
            configViewModel.secondTeamName,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: generalCardDecoration,
            child: ListTile(
              title: Text(
                "Number of Player/Team",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "${configViewModel.numberOfPlayer} Players",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: generalCardDecoration,
            child: ListTile(
              title: Text(
                "Number of Over",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "${configViewModel.numberOfOvers} Overs",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: generalCardDecoration,
            child: ListTile(
              title: Text(
                "Maximum over/Bowler",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "${configViewModel.maxOverPerBowler} Overs",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: generalCardDecoration,
            child: ListTile(
              title: Text(
                "Toss",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "${configViewModel.tossWinningTeam == TeamNo.FIRST ? configViewModel.firstTeamName : configViewModel.secondTeamName} won the toss and elected to ${configViewModel.tossWinnerElectedType == TossWinningType.BATTING ? "BAT" : "FIELDING"} first",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerList extends StatelessWidget {
  final TeamNo teamNo;


  const PlayerList({Key key, @required this.teamNo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    return ListView.builder(
      itemCount: configViewModel.numberOfPlayer,
      itemBuilder: (_, index) {
        String name = "";
        if (teamNo == TeamNo.FIRST)
          name =
              "${configViewModel.firstTeamFirstName[index]} ${configViewModel.firstTeamLastName[index]}";
        else
          name =
              "${configViewModel.secondTeamFirstName[index]} ${configViewModel.secondTeamLastName[index]}";
        final type = teamNo == TeamNo.FIRST
            ? configViewModel.firstTeamPlayerType[index]
            : configViewModel.secondTeamPlayerType[index];
        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: generalCardDecoration,
          child: ListTile(
            trailing: Image.asset(
              PLAYER_TYPE_ICON[type],
              height: 20,
              width: 20,
            ),
            title: Text(
              name,
            ),
          ),
        );
      },
    );
  }
}
