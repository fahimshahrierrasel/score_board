import 'package:flutter/material.dart';
import 'package:score_board/views/sub_screens/team_match/team_match.dart';


class TeamMatch extends StatefulWidget {
  @override
  _TeamMatchState createState() => _TeamMatchState();
}

class _TeamMatchState extends State<TeamMatch> {
  int currentStep = 0;
  PageController _pageController;
  String title = "Match Configuration";

  @override
  void initState() {
    _pageController = PageController(initialPage: currentStep)
      ..addListener(() {
        setState(() {
          if (currentStep == 0)
            title = "Match Configuration";
          if (currentStep == 1)
            title = "First Team Players";
          else if (currentStep == 2)
            title = "Second Team Players";
          else if (currentStep == 3)
            title = "Toss";
          else if (currentStep == 4)
            title = "Summery";
        });
      });
    super.initState();
  }

  void _goToNextPage(){
    setState(() {
      currentStep = currentStep + 1;
    });
    _pageController.jumpToPage(currentStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: WillPopScope(
        onWillPop: () {
          setState(() {
            currentStep = currentStep - 1;
          });
          if (currentStep < 0) {
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
            Summery(),
          ],
        ),
      ),
    );
  }
}
