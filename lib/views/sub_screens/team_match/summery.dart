import 'package:flutter/material.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class Summery extends StatelessWidget {
  final Function onConfirmPress;

  const Summery({Key key, @required this.onConfirmPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new TabBar(
          tabs: [
            Tab(
              text: "Details".toUpperCase(),
            ),
            Tab(
              text: "Team A".toUpperCase(),
            ),
            Tab(
              text: "Team B".toUpperCase(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  MatchDetails(),
                  PlayerList(),
                  PlayerList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatRoundedButton(
                title: "Confirm",
                onPress: onConfirmPress,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            "Team A",
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
            "Team B",
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
                "7 Players",
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
                "20 Overs",
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
                "4 Overs",
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
                "Team A won the toss and elected to BAT first",
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 11,
      itemBuilder: (_, index) {
        final icon = index % 2 == 0
            ? "assets/images/bat.png"
            : index % 3 == 0
                ? "assets/images/all_rounder.png"
                : "assets/images/ball.png";
        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: generalCardDecoration,
          child: ListTile(
            trailing: Image.asset(icon, height: 20, width: 20,),
            title: Text("Fahim Shahrier Rasel",),
          ),
        );
      },
    );
  }
}
