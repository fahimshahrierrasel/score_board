import 'package:flutter/material.dart';

class AppSlider extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function onChange;

  const AppSlider(
      {Key key,
        @required this.value,
        @required this.min,
        @required this.max,
        @required this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData().copyWith(
          trackHeight: 12,
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
          thumbColor: Theme.of(context).primaryColor.withOpacity(0.65),
          activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.65),
          inactiveTrackColor: Colors.black.withOpacity(0.05)),
      child: Slider(
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: (max - min) + 1,
        value: value.toDouble(),
        onChanged: onChange,
      ),
    );
  }
}