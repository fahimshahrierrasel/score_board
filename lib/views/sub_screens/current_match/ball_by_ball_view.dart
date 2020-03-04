import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/db_models/innings.dart';
import 'package:score_board/data/models/ball_details.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/helpers/extensions.dart';
import 'package:score_board/main.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:sqlcool/sqlcool.dart';

class BallByBallView extends StatefulWidget {
  final Innings currentInnings;
  const BallByBallView({
    Key key,
    @required this.currentInnings,
  }) : super(key: key);

  @override
  _BallByBallViewState createState() => _BallByBallViewState();
}

class _BallByBallViewState extends State<BallByBallView> {
  SelectBloc oversBloc;

  @override
  void initState() {
    super.initState();
    oversBloc = SelectBloc(
      database: appDb,
      table: overTableName,
      where: "innings_id = ${widget.currentInnings.id}",
      reactive: true,
      orderBy: "number",
    );
  }

  @override
  void dispose() {
    oversBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: generalCardDecoration,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Text("Ball by Ball Views"),
          StreamBuilder<List<Map>>(
            stream: oversBloc.items,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Over> overs = [];
                List<Ball> allBalls = [];
                allBalls.clear();
                snapshot.data.forEach((row) =>
                    overs.add(Over().fromDb(row as Map<String, dynamic>)));
                overs
                    .forEach((over) => allBalls.addAll(over.ballDetails.balls));
                allBalls = allBalls.reversed.toList();

                // Calculating Extra Runs
                final wideBalls = allBalls
                    .where((ball) => ball.ballType == BallType.WD.value)
                    .length;
                final noBalls = allBalls
                    .where((ball) => ball.ballType == BallType.NB.value)
                    .length;

                final totalExtras = wideBalls + noBalls;

                return Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: allBalls.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final ball = allBalls[index];
                          bool isExtraRunBall = false;
                          bool isWicket = false;
                          String ballText = "";
                          if (ball.ballType == BallType.VALID.value) {
                            ballText = ball.run.toString();
                          } else if (ball.ballType == BallType.NB.value) {
                            isExtraRunBall = true;
                            ballText = ball.run > 0 ? "NB+${ball.run}" : "NB";
                          } else if (ball.ballType == BallType.WD.value) {
                            isExtraRunBall = true;
                            ballText = ball.run > 0 ? "WD+${ball.run}" : "WD";
                          } else if (ball.ballType == BallType.B.value) {
                            isExtraRunBall = true;
                            ballText = "B+${ball.run}";
                          } else if (ball.ballType == BallType.W.value) {
                            isWicket = true;
                            ballText = "W";
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isExtraRunBall
                                  ? Colors.yellow
                                  : isWicket ? Colors.red : Color(0xffdd8d8d8),
                            ),
                            child: Text(
                              ballText,
                              style: isExtraRunBall
                                  ? GoogleFonts.oswald(fontSize: 16)
                                  : GoogleFonts.oswald(
                                      fontSize: 20,
                                      color: isWicket
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                        "Extra : $totalExtras (B 0, LB 0, WD $wideBalls, NB $noBalls)"),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
