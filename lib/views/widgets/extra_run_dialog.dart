import 'package:flutter/material.dart';
import 'package:score_board/helpers/constants.dart';

class ExtraRunDialog extends StatefulWidget {
  final String title;
  final ExtraType extraType;

  const ExtraRunDialog({Key key, this.title, this.extraType}) : super(key: key);

  @override
  _ExtraRunDialogState createState() => _ExtraRunDialogState();
}

class _ExtraRunDialogState extends State<ExtraRunDialog> {
  int extraRunTypeGroupValue = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "How many extra run on this ${widget.title}?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            // Bye can not have 0 run
            children: [0, 1, 2, 3, 4, 5, 6]
                .reversed
                .map(
                  (run) => FloatingActionButton(
                    heroTag: "${widget.title} $run",
                    mini: true,
                    child: Text(run.toString()),
                    onPressed: () {
                      Map<String, dynamic> extraRun = new Map();
                      if (widget.extraType != ExtraType.NB) {
                        extraRun[EXTRA_RUN_TYPE] = BallRunType.BYE;
                      } else {
                        extraRun[EXTRA_RUN_TYPE] = extraRunTypeGroupValue == 0
                            ? BallRunType.BAT
                            : BallRunType.BYE;
                      }
                      extraRun[EXTRA_RUN] = run;
                      Navigator.of(context).pop(extraRun);
                    },
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 10,
          ),
          // TODO: Bad practice of if conditions will update it later
          if (widget.extraType == ExtraType.NB)
            Text("Run comes from"),
          if (widget.extraType == ExtraType.NB)
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio<int>(
                      value: 0,
                      groupValue: extraRunTypeGroupValue,
                      onChanged: (value) {
                        setState(() {
                          extraRunTypeGroupValue = value;
                        });
                      },
                    ),
                    Text("Bat")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<int>(
                      value: 1,
                      groupValue: extraRunTypeGroupValue,
                      onChanged: (value) {
                        setState(() {
                          extraRunTypeGroupValue = value;
                        });
                      },
                    ),
                    Text("Bye")
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
