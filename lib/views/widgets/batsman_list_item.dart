import 'package:flutter/material.dart';

class BatsmanListItem extends StatelessWidget {
  final String name;
  final int runs;
  final int ballFaced;
  final int fours;
  final int sixes;
  final bool onStrike;
  final bool isHeader;
  final bool whiteHeader;
  final String outDetails;


  const BatsmanListItem({
    Key key,
    this.name,
    this.runs,
    this.ballFaced,
    this.fours,
    this.sixes,
    this.outDetails,
    this.onStrike = false,
    this.isHeader = false, this.whiteHeader = false,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isHeader ? "Batsman" : "$name ${onStrike ? "🏏" : ""}",
                  style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                ),
                !isHeader && outDetails != null ? Text(outDetails, style: TextStyle(fontSize: 12, color: Color(0xff9A9A9A)),) : Container(color: Colors.red,)
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    isHeader ? "R" : runs.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "B" : ballFaced.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "4s" : fours.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader ? "6s" : sixes.toString(),
                    textAlign: TextAlign.center,
                    style: isHeader && !whiteHeader ? TextStyle(color: Colors.white) : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    isHeader
                        ? "SR"
                        : "${((runs / ballFaced) * 100).toStringAsFixed(1)}",
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
