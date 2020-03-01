import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/views/sub_screens/team_match/team_match.dart';

class TeamMatch extends StatefulWidget {
  @override
  _TeamMatchState createState() => _TeamMatchState();
}

class _TeamMatchState extends State<TeamMatch> {
  int currentStep = 0;
  PageController _pageController;
  String title = "Match Configuration";
  String firstTeamName = "First Team";
  String secondTeamName = "Second Team";

  @override
  void initState() {
    _pageController = PageController(initialPage: currentStep)
      ..addListener(() {
        setState(() {
          if (currentStep == 0) title = "Match Configuration";
          if (currentStep == 1)
            title = "$firstTeamName Players";
          else if (currentStep == 2)
            title = "$secondTeamName Players";
          else if (currentStep == 3)
            title = "Toss";
          else if (currentStep == 4) title = "Summery";
        });
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    firstTeamName = configViewModel.firstTeamName;
    secondTeamName = configViewModel.secondTeamName;
  }

  void _goToNextPage() {
    setState(() {
      currentStep = currentStep + 1;
    });
    _pageController.jumpToPage(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final configViewModel = Provider.of<MatchConfigViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Image.asset(
          "assets/images/team_match.jpg",
          fit: BoxFit.cover,
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          setState(() {
            currentStep = currentStep - 1;
          });
          if (currentStep < 0) {
            configViewModel.reset();
            return new Future(() => true);
          }
          _pageController.jumpToPage(currentStep);
          return new Future(() => false);
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            MatchConfiguration(
              onNextPress: _goToNextPage,
            ),
            FirstTeamPlayers(
              onNextPress: _goToNextPage,
            ),
            SecondTeamPlayers(
              onNextPress: _goToNextPage,
            ),
            Toss(
              onNextPress: _goToNextPage,
            ),
            Summery(
              onConfirmPress: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
