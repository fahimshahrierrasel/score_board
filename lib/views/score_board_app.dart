import 'package:flutter/material.dart';
import 'package:score_board/views/commons/app_theme.dart';
import 'package:score_board/views/screens/home_page.dart';

class ScoreBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Board',
      theme: getAppTheme(context),
      home: HomePage(),
    );
  }
}