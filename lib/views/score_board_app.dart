import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/main.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/viewmodels/match_list_viewmodel.dart';
import 'package:score_board/views/commons/app_theme.dart';
import 'package:score_board/views/screens/home_page.dart';

class ScoreBoardApp extends StatefulWidget {
  @override
  _ScoreBoardAppState createState() => _ScoreBoardAppState();
}

class _ScoreBoardAppState extends State<ScoreBoardApp> {
  bool databaseReady = false;

  @override
  void initState() {
    appDb.onReady.then((_) {
      setState(() {
        databaseReady = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MatchConfigViewModel>(
          create: (_) => MatchConfigViewModel(),
        ),
        ChangeNotifierProvider<MatchListViewModel>(
          create: (_) => MatchListViewModel(),
        ),
        ChangeNotifierProvider<CurrentMatchViewModel>(
          create: (_) => CurrentMatchViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Score Board',
        theme: getAppTheme(context),
        home: databaseReady
            ? HomePage()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
