import 'package:flutter/material.dart';

class CoinSide extends StatelessWidget {
  final String title;
  final Function coinClicked;
  final double rotationX;

  const CoinSide({
    Key key,
    @required this.title,
    this.coinClicked,
    this.rotationX = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()..rotateX(rotationX),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 3.0),
              blurRadius: 6,
            ),
          ],
        ),
        child: new Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          shape: CircleBorder(),
          child: new InkWell(
            onTap: coinClicked,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}