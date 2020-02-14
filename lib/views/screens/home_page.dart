import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:score_board/data/services/repository.dart';
import 'package:score_board/viewmodels/match_list_viewmodel.dart';
import 'package:score_board/views/commons/app_drawer.dart';
import 'package:score_board/views/commons/fade_page_route.dart';
import 'package:score_board/views/screens/create_match.dart';
import 'package:score_board/views/screens/team_match.dart';
import 'package:score_board/views/widgets/home_page_tabs.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Score Board",
          style: GoogleFonts.montserrat(),
        ),
      ),
      drawer: appDrawer,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(FadePageRoute(builder: (context) => CreateMatch()));
        },
      ),
      body: Consumer<MatchListViewModel>(
        builder: (_, matchListViewModel, __) {
          return FutureBuilder<bool>(
            future: matchListViewModel.getMatches(),
            builder: (_context, snapshot) {
              if (snapshot.hasData) {
                return HomePageTabs();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
