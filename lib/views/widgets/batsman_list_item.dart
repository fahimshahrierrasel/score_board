import 'package:flutter/material.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class BatsmanListItem extends StatefulWidget {
  final Player player;
  final Innings innings;
  final bool onStrike;

  const BatsmanListItem({
    Key key,
    @required this.player,
    @required this.innings,
    this.onStrike = false,
  }) : super(key: key);

  @override
  _BatsmanListItemState createState() => _BatsmanListItemState();
}

class _BatsmanListItemState extends State<BatsmanListItem> {
  SelectBloc batsmanBloc;
  @override
  void initState() {
    super.initState();
    batsmanBloc = SelectBloc(
      database: appDb,
      table: battingTableName,
      where:
          "player_id = ${widget.player.id} AND innings_id = ${widget.innings.id}",
      limit: 1,
      reactive: true,
    );
  }

  @override
  void dispose() {
    batsmanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<List<Map>>(
        stream: batsmanBloc.items,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Batting batting = Batting().fromDb(snapshot.data[0]);
            return Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.player.lastName} ${widget.onStrike ? "🏏" : ""}",
                      ),
                      if (batting.wicketInfo.type != null)
                        Text(
                          batting.wicketInfo.toJson(),
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff9A9A9A)),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          batting.runDetails.calculateRuns().toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          batting.runDetails.calculateBalls().toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          batting.runDetails.four.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          batting.runDetails.six.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${batting.runDetails.calculateStrikeRate().toStringAsFixed(1)}",
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
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
