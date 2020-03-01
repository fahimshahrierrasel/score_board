import 'package:flutter/material.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/models/models.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

extension on BallType {
  String get value => this.toString().split('.').last;
}

class BowlerListItem extends StatefulWidget {
  final Player player;
  final Innings innings;

  const BowlerListItem({Key key, this.player, this.innings}) : super(key: key);

  @override
  _BowlerListItemState createState() => _BowlerListItemState();
}

class _BowlerListItemState extends State<BowlerListItem> {
  SelectBloc bowlerBloc;

  @override
  void initState() {
    super.initState();
    bowlerBloc = SelectBloc(
      database: appDb,
      table: overTableName,
      where:
          "player_id = ${widget.player.id} AND innings_id = ${widget.innings.id}",
      reactive: true,
    );
  }

  @override
  void dispose() {
    bowlerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<List<Map>>(
        stream: bowlerBloc.items,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final List<Over> overs = deserializeOvers(snapshot.data);
            final List<Ball> allBalls = [];
            allBalls.clear();
            overs.forEach((over) => allBalls.addAll(over.ballDetails.balls));

            int validBalls = calculateValidBalls(allBalls);
            int overForEconomy =
                (validBalls / 6).floor() == 0 ? 1 : (validBalls / 6).floor();
            int runs = calculateRuns(allBalls);
            return Row(
              children: <Widget>[
                Expanded(child: Text(widget.player.lastName)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${(validBalls / 6).floor()}${validBalls % 6 > 0 ? "." : ""}${validBalls % 6 > 0 ? (validBalls % 6) : ""}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "M",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          runs.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "W",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${(runs / overForEconomy.toDouble()).toStringAsFixed(1)}",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  List<Over> deserializeOvers(List<Map> rows) {
    List<Over> overs = [];
    rows.forEach((row) => overs.add(Over().fromDb(row)));
    return overs;
  }

  int calculateValidBalls(List<Ball> allBalls) {
    final validBalls = allBalls.where((ball) =>
        ball.ballType == BallType.VALID.value ||
        ball.ballType == BallType.B.value ||
        ball.ballType == BallType.W.value);
    return validBalls.length;
  }

  int calculateRuns(List<Ball> allBalls) {
    int runs = 0;
    allBalls.forEach((ball){
      if(ball.ballType == BallType.NB.value)
        runs = runs + ball.run + 1;
      else if(ball.ballType == BallType.WD.value)
        runs = runs + ball.run + 1;
      else if(ball.ballType == BallType.VALID.value)
        runs = runs + ball.run;
    });
    return runs;
  }
}
