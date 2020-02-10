import 'package:flutter/material.dart';
import 'package:score_board/views/commons/decorations.dart';

class ScoreControlButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  const ScoreControlButton(
      {Key key,
        this.title,
        this.icon,
        this.backgroundColor,
        this.textColor,
        @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: scoreControlDecoration.copyWith(color: backgroundColor),
            child: icon != null
                ? Icon(
              icon,
              color: textColor,
            )
                : Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}