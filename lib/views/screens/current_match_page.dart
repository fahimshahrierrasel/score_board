import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/views/sub_screens/current_match/match_control.dart';
import 'package:score_board/views/sub_screens/current_match/score_card.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class CurrentMatchPage extends StatefulWidget {
  final Match match;
  final Team firstTeam;
  final Team secondTeam;

  const CurrentMatchPage({
    Key key,
    this.match,
    this.firstTeam,
    this.secondTeam,
  }) : super(key: key);

  @override
  _CurrentMatchPageState createState() => _CurrentMatchPageState();
}

class _CurrentMatchPageState extends State<CurrentMatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CurrentMatchViewModel>(
        builder: (_, currentMatchViewModel, __) {
          return FutureProvider<bool>(
            create: (_) async {
              currentMatchViewModel.setMatchNTeam(
                  widget.match, widget.firstTeam, widget.secondTeam);
              await currentMatchViewModel.checkMatchStarted();
              return Future<bool>.value(currentMatchViewModel.isMatchStarted);
            },
            child: Consumer<bool>(
              builder: (_, result, __) {
                if (currentMatchViewModel.isMatchStarted) {
                  return _buildMatchTabController(currentMatchViewModel);
                } else {
                  return _buildMatchStartConsent(currentMatchViewModel);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchStartConsent(CurrentMatchViewModel currentMatchViewModel) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Do you want to start the match?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          FlatRoundedButton(
            title: "Start",
            onPress: () {
              currentMatchViewModel.createMatchInnings();
            },
          )
        ],
      ),
    );
  }

  DefaultTabController _buildMatchTabController(
      CurrentMatchViewModel currentMatchViewModel) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (menuString) async {
                // It should always comes from Complete Innings.
                if (menuString != "complete") return;
                var message = "Are you want to complete this innings?";
                if (!currentMatchViewModel.isInningsComplete()) {
                  message = "Looks like current innings is not completed yet! "
                      "Are you sure want to forcefully completed the innings?";
                }
                final decision = await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) {
                    // return object of type Dialog
                    return InningsCompleteDialog(
                      message: message,
                    );
                  },
                );
                if(decision != null && decision) {
                  await currentMatchViewModel.announceInningsComplete();
                  Navigator.of(context).pop();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "complete",
                    child: Text("Complete Innings"),
                  )
                ];
              },
            ),
          ],
          title: Text("${widget.firstTeam.name} vs ${widget.secondTeam.name}"),
          flexibleSpace: Image.asset(
            "assets/images/team_match.jpg",
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          bottom: new TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            tabs: [
              Tab(
                text: "Cockpit".toUpperCase(),
              ),
              Tab(
                text: "ScoreCard".toUpperCase(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MatchControl(),
            ScoreCard(),
          ],
        ),
      ),
    );
  }
}

class InningsCompleteDialog extends StatelessWidget {
  final String message;

  const InningsCompleteDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      title: Text("Do you want to complete this innings?"),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          child: Text(
            "Yes",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        RaisedButton(
          child: Text(
            "No",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        )
      ],
      content: Text(
        message,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
