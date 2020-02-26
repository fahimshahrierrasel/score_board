import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/db_models/innings.dart';
import 'package:score_board/data/models/ball_details.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                return Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: allBalls.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffdd8d8d8),
                        ),
                        child: Text(
                          allBalls[index].run.toString(),
                          style: GoogleFonts.oswald(fontSize: 20),
                        ),
                      );
                    },
                  ),
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
