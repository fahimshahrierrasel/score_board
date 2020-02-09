import 'package:flutter/material.dart';

class BowlerListItem extends StatelessWidget {
  final String name;
  final int balls;
  final int maidens;
  final int runs;
  final int wickets;
  final bool isHeader;
  final bool whiteHeader;

  const BowlerListItem({
    Key key,
    this.name,
    this.balls,
    this.maidens,
    this.runs,
    this.wickets,
    this.isHeader = false,
    this.whiteHeader = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: isHeader
          ? BoxDecoration(
              color: whiteHeader ? Colors.grey : Theme.of(context).primaryColor,
              borderRadius: !whiteHeader ? BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ) : null,
            )
          : null,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            isHeader ? "Bowler" : name,
            style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
          )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    isHeader
                        ? "O"
                        : "${(balls / 6).floor()}${balls % 6 > 0 ? "." : ""}${balls % 6 > 0 ? (balls % 6) : ""}",
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "M" : maidens.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "R" : runs.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "W" : wickets.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader
                        ? "ECO"
                        : "${(runs / (balls / 6).floor()).toStringAsFixed(1)}",
                    textAlign: TextAlign.end,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
