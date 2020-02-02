import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
                        "Team A",
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
                        "Team B",
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
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                        child: Text(tossResult, textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
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
                                ? "First Team"
                                : "Second Team";

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
                              tossResult = "$winningTeam won the toss and elected to ${result ? "BAT" : "FIELD"} first";
                            });
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
            onPress: widget.onNextPress,
          )
        ],
      ),
    );
  }
}

class CoinSide extends StatelessWidget {
  final String title;
  final Function coinClicked;
  final double rotationX;

  const CoinSide({
    Key key,
    @required this.title,
    this.coinClicked,
    this.rotationX = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()..rotateX(rotationX),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 3.0),
              blurRadius: 6,
            ),
          ],
        ),
        child: new Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          shape: CircleBorder(),
          child: new InkWell(
            onTap: coinClicked,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
