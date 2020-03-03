import 'package:flutter/material.dart';

class PlayerTypeRadioGroup extends StatelessWidget {
  final int groupValue;
  final Function onChange;

  const PlayerTypeRadioGroup({Key key, this.groupValue, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio<int>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: 0,
              groupValue: groupValue,
              onChanged: onChange,
            ),
            Text("Batsman")
          ],
        ),
        Row(
          children: <Widget>[
            Radio<int>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: 1,
              groupValue: groupValue,
              onChanged: onChange,
            ),
            Text("Bowler")
          ],
        ),
        Row(
          children: <Widget>[
            Radio<int>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: 2,
              groupValue: groupValue,
              onChanged: onChange,
            ),
            Text("All Rounder")
          ],
        ),
      ],
    );
  }
}
