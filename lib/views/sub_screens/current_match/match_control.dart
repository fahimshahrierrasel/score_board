import 'package:expandable/expandable.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/views/sub_screens/current_match/score_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:score_board/viewmodels/current_match_viewmodel.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/commons/fade_page_route.dart';
import 'package:score_board/views/sub_screens/current_match/ball_by_ball_view.dart';
import 'package:score_board/views/sub_screens/current_match/player_selector.dart';
import 'package:score_board/views/widgets/batsman_list_item.dart';
import 'package:score_board/views/widgets/batsman_list_item_header.dart';
import 'package:score_board/views/widgets/bowler_list_item.dart';
import 'package:score_board/views/widgets/bowler_list_item_header.dart';
import 'package:score_board/views/widgets/score_control_button.dart';

class MatchControl extends StatefulWidget {
  @override
  _MatchControlState createState() => _MatchControlState();
}

class _MatchControlState extends State<MatchControl> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<CurrentMatchViewModel>(
        builder: (_, currentMatchViewModel, __) {
          return FutureProvider<bool>(
            create: (_) => currentMatchViewModel.setUpInnings(),
            catchError: (_, err) {
             print(err);
             return false;
            },
            child: Consumer<bool>(
              builder: (_, isSetUpComplete, __) {
                if (isSetUpComplete != null && isSetUpComplete) {
                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: generalCardDecoration,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: ExpandablePanel(
                          collapsed: Container(
                            child: ScoreBoard(
                              currentMatchViewModel: currentMatchViewModel,
                            ),
                          ),
                          expanded: Column(
                            children: <Widget>[
                              Container(
                                child: ScoreBoard(
                                  currentMatchViewModel: currentMatchViewModel,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              StaggeredGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                children: getStaggeredItems(
                                    context, currentMatchViewModel),
                                staggeredTiles: getStaggeredTiles(),
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Text("Extra : 12 (B 0, LB 0, WD 10, NB 2)"),
                      BallByBallView(
                        currentInnings: currentMatchViewModel.currentInnings,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: generalCardDecoration,
                        child: Column(
                          children: <Widget>[
                            BatsmanListItemHeader(
                              onTap: () async {
                                if (currentMatchViewModel.firstBatsman ==
                                        null ||
                                    currentMatchViewModel.secondBatsman ==
                                        null) {
                                  // TODO handle player not selected
                                  final player = await Navigator.of(context)
                                      .push(FadePageRoute(
                                    builder: (context) => PlayerSelector(
                                        teamId: currentMatchViewModel
                                            .currentInnings.battingTeamId),
                                    fullscreenDialog: true,
                                  ));
                                  await currentMatchViewModel
                                      .setBatsman(player);
                                }
                              },
                            ),
                            if (currentMatchViewModel.firstBatsman != null)
                              BatsmanListItem(
                                player: currentMatchViewModel.firstBatsman,
                                innings: currentMatchViewModel.currentInnings,
                                onStrike:
                                    currentMatchViewModel.firstBatsmanBatting ==
                                        currentMatchViewModel.strikeBatsman,
                              ),
                            if (currentMatchViewModel.secondBatsman != null)
                              BatsmanListItem(
                                player: currentMatchViewModel.secondBatsman,
                                innings: currentMatchViewModel.currentInnings,
                                onStrike: currentMatchViewModel
                                        .secondBatsmanBatting ==
                                    currentMatchViewModel.strikeBatsman,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: generalCardDecoration,
                        child: Column(
                          children: <Widget>[
                            BowlerListItemHeader(
                              onTap: () async {
                                // Handle player not selected
                                final player = await Navigator.of(context)
                                    .push(FadePageRoute(
                                  builder: (context) => PlayerSelector(
                                      teamId: currentMatchViewModel
                                          .currentInnings.bowlingTeamId),
                                  fullscreenDialog: true,
                                ));
                                await currentMatchViewModel.setBowler(player);
                              },
                            ),
                            if (currentMatchViewModel.currentBowler != null)
                              BowlerListItem(
                                player: currentMatchViewModel.currentBowler,
                                innings: currentMatchViewModel.currentInnings,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  List<Widget> getStaggeredItems(
      BuildContext context, CurrentMatchViewModel currentMatchViewModel) {
    List<Widget> _tiles = <Widget>[
      ScoreControlButton(
        title: "Wicket",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        onTap: () {},
      ),
      ScoreControlButton(
        icon: Icons.undo,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onTap: () {},
      ),
      ScoreControlButton(
        title: "WD",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControlButton(
        title: "NB",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControlButton(
        title: "LB",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControlButton(
        title: "4",
        backgroundColor: Colors.green,
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.FOUR);
        },
      ),
      ScoreControlButton(
        title: "6",
        backgroundColor: Colors.green,
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.SIX);
        },
      ),
      ScoreControlButton(
        title: "0",
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.ZERO);
        },
      ),
      ScoreControlButton(
        title: "1",
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.ONE);
        },
      ),
      ScoreControlButton(
        title: "2",
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.TWO);
        },
      ),
      ScoreControlButton(
        title: "3",
        onTap: () {
          currentMatchViewModel.countRunNBall(RUN_TYPE.THREE);
        },
      ),
    ];
    return _tiles;
  }

  List<StaggeredTile> getStaggeredTiles() {
    List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
      const StaggeredTile.extent(3, 40),
      const StaggeredTile.extent(1, 88),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(2, 40),
      const StaggeredTile.extent(2, 40),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(1, 40),
      const StaggeredTile.extent(1, 40),
    ];
    return _staggeredTiles;
  }
}
