import 'package:flutter/material.dart';

class BowlerListItemHeader extends StatelessWidget {
  final bool whiteHeader;
  final Function onTap;

  const BowlerListItemHeader({Key key, this.whiteHeader = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: whiteHeader ? Colors.grey : Theme.of(context).primaryColor,
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
                child: Text(
              "Bowler",
              style: !whiteHeader ? TextStyle(color: Colors.white) : null,
            )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "O",
                      textAlign: TextAlign.center,
                      style: !whiteHeader ? TextStyle(color: Colors.white) : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "M",
                      textAlign: TextAlign.center,
                      style: !whiteHeader ? TextStyle(color: Colors.white) : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "R",
                      textAlign: TextAlign.center,
                      style: !whiteHeader ? TextStyle(color: Colors.white) : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "W",
                      textAlign: TextAlign.center,
                      style: !whiteHeader ? TextStyle(color: Colors.white) : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "ECO",
                      textAlign: TextAlign.end,
                      style: !whiteHeader ? TextStyle(color: Colors.white) : null,
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
