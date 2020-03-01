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
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentMatchViewModel = Provider.of<CurrentMatchViewModel>(context);
    currentMatchViewModel.setMatchNTeam(
        widget.match, widget.firstTeam, widget.secondTeam);
    currentMatchViewModel.checkMatchStarted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CurrentMatchViewModel>(
        builder: (_, currentMatchViewModel, __) {
          if (currentMatchViewModel.isMatchStarted) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("${widget.firstTeam.name} vs ${widget.secondTeam.name}"),
                  flexibleSpace: Image.asset("assets/images/team_match.jpg", fit: BoxFit.cover,),
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
          } else {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Do you want to start the match?",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
        },
      ),
    );
  }
}
