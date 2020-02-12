import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/views/commons/app_theme.dart';
import 'package:score_board/views/screens/home_page.dart';

class ScoreBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MatchConfigViewModel>(
          create: (_) => MatchConfigViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Score Board',
        theme: getAppTheme(context),
        home: HomePage(),
      ),
    );
  }
}