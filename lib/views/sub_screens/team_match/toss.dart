import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/views/widgets/coin_side.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';
import 'package:score_board/views/widgets/toss_decision_dialog.dart';

class Toss extends StatefulWidget {
  final Function onNextPress;

  const Toss({Key key, @required this.onNextPress}) : super(key: key);

  @override
  _TossState createState() => _TossState();
}

class _TossState extends State<Toss> with SingleTickerProviderStateMixin {
  bool firstTeamHead = true;
  Animation animation;
  AnimationController animationController;
  String coinText = "HEAD";
  String tossResult = "";
  Timer _timer;
  double rotationX = 100;
  String firstTeamName;
  String secondTeamName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    firstTeamName = configViewModel.firstTeamName;
    secondTeamName = configViewModel.secondTeamName;
    if (configViewModel.tossWinningTeam != null)
      tossResult =
          "${configViewModel.tossWinningTeam == TeamNo.FIRST ? configViewModel.firstTeamName : configViewModel.secondTeamName} won the toss and elected to ${configViewModel.tossWinnerElectedType == TossWinningType.BATTING ? "BAT" : "FIELDING"} first";
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    animation = IntTween(begin: 0, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        firstTeamName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "VS",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        secondTeamName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CoinSide(
                        title: firstTeamHead ? "HEAD" : "TAILS",
                        coinClicked: () {
                          setState(() {
                            firstTeamHead = !firstTeamHead;
                          });
                        },
                      ),
                      CoinSide(
                        title: !firstTeamHead ? "HEAD" : "TAILS",
                        coinClicked: () {
                          setState(() {
                            firstTeamHead = !firstTeamHead;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (_, __) {
                          return CoinSide(
                            title: coinText,
                            rotationX: rotationX,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 40.0),
                        child: Text(
                          tossResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      FlatButton(
                        child: Text("Toss"),
                        onPressed: () {
                          setState(() {
                            tossResult = "";
                          });
                          _timer = Timer.periodic(Duration(milliseconds: 50),
                              (time) {
                            final double angle = 30 * ((time.tick % 12.0) + 1);
                            setState(() {
                              coinText = time.tick % 3 == 0 ? "TAILS" : "HEAD";
                              rotationX = angle;
                            });
                          });

                          Future.delayed(Duration(seconds: 3), () async {
                            _timer.cancel();
                            final randomToss = new Random().nextBool();
                            String winningTeam = randomToss == firstTeamHead
                                ? firstTeamName
                                : secondTeamName;

                            final result = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext _context) {
                                // return object of type Dialog
                                return TossDecisionDialog(
                                  winningTeam: winningTeam,
                                );
                              },
                            );

                            setState(() {
                              coinText = randomToss ? "HEAD" : "TAILS";
                              rotationX = 0;
                              tossResult =
                                  "$winningTeam won the toss and elected to ${result ? "BAT" : "FIELD"} first";
                            });
                            configViewModel.setTossResult(
                                randomToss == firstTeamHead
                                    ? TeamNo.FIRST
                                    : TeamNo.SECOND,
                                result
                                    ? TossWinningType.BATTING
                                    : TossWinningType.FIELDING);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          FlatRoundedButton(
            title: "Next",
            onPress: () {
              if (configViewModel.tossWinningTeam != null)
                widget.onNextPress();
              else
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("You need to toss first."),
                ));
            },
          )
        ],
      ),
    );
  }
}
