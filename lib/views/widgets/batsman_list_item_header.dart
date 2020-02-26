import 'package:flutter/material.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class BatsmanListItemHeader extends StatelessWidget {
  final bool whiteHeader;
  final Function onTap;

  const BatsmanListItemHeader({
    Key key,
    this.whiteHeader = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
                color: whiteHeader
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                borderRadius: !whiteHeader
                    ? BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      )
                    : null,
              ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("Batsman",
                style: !whiteHeader
                    ? TextStyle(color: Colors.white)
                    : null,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text("R",
                      textAlign: TextAlign.center,
                      style: !whiteHeader
                          ? TextStyle(color: Colors.white)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text("B",
                      textAlign: TextAlign.center,
                      style: !whiteHeader
                          ? TextStyle(color: Colors.white)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text("4s",
                      textAlign: TextAlign.center,
                      style: !whiteHeader
                          ? TextStyle(color: Colors.white)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text( "6s",
                      textAlign: TextAlign.center,
                      style: !whiteHeader
                          ? TextStyle(color: Colors.white)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text("SR",
                      textAlign: TextAlign.end,
                      style: !whiteHeader
                          ? TextStyle(color: Colors.white)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
