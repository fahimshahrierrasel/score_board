import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/widgets/batsman_list_item.dart';
import 'package:score_board/views/widgets/batsman_list_item.dart';
import 'package:score_board/views/widgets/bowler_list_item.dart';
import 'package:score_board/views/widgets/bowler_list_item.dart';
import 'package:score_board/views/widgets/score_control_button.dart';

class MatchControl extends StatefulWidget {
  @override
  _MatchControlState createState() => _MatchControlState();
}

class _MatchControlState extends State<MatchControl> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: generalCardDecoration,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: ExpandablePanel(
              collapsed: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Team A",
                              style: GoogleFonts.oswald(fontSize: 36),
                            ),
                            Text("CRR: 8.77"),
                            Text("RRR: 0.00")
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "153/10",
                              style: GoogleFonts.oswald(fontSize: 48),
                            ),
                            Text(
                              "16.2 Overs",
                              style: GoogleFonts.oswald(fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                    ExpandableButton(
                      child: Icon(Icons.expand_more),
                    )
                  ],
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Team A",
                                  style: GoogleFonts.oswald(fontSize: 36),
                                ),
                                Text("CRR: 8.77"),
                                Text("RRR: 0.00")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "153/10",
                                  style: GoogleFonts.oswald(fontSize: 48),
                                ),
                                Text(
                                  "16.2 Overs",
                                  style: GoogleFonts.oswald(fontSize: 20),
                                )
                              ],
                            )
                          ],
                        ),
                        ExpandableButton(
                          child: Icon(Icons.expand_less),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StaggeredGridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: getStaggeredItems(context),
                    staggeredTiles: getStaggeredTiles(),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  )
                ],
              ),
            ),
          ),
          Text("Extra : 12 (B 0, LB 0, WD 10, NB 2)"),
          Container(
            decoration: generalCardDecoration,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: <Widget>[
                Text("Ball by Ball Views"),
                Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    itemCount: 20,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffdd8d8d8),
                        ),
                        child: Text(
                          "4",
                          style: GoogleFonts.oswald(fontSize: 20),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: generalCardDecoration,
            child: Column(
              children: <Widget>[
                BatsmanListItem(
                  isHeader: true,
                ),
                BatsmanListItem(
                  name: "Fahim",
                  runs: 20,
                  ballFaced: 18,
                  fours: 2,
                  sixes: 1,
                  onStrike: true,
                ),
                BatsmanListItem(
                  name: "Fahim Shahrier",
                  runs: 20,
                  ballFaced: 18,
                  fours: 2,
                  sixes: 1,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: generalCardDecoration,
            child: Column(
              children: <Widget>[
                BowlerListItem(
                  isHeader: true,
                ),
                BowlerListItem(
                  name: "Rasel",
                  balls: 30,
                  runs: 25,
                  maidens: 0,
                  wickets: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getStaggeredItems(BuildContext context) {
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
        onTap: () {},
      ),
      ScoreControlButton(
        title: "6",
        backgroundColor: Colors.green,
        onTap: () {},
      ),
      ScoreControlButton(
        title: "0",
        onTap: () {},
      ),
      ScoreControlButton(
        title: "1",
        onTap: () {},
      ),
      ScoreControlButton(
        title: "2",
        onTap: () {},
      ),
      ScoreControlButton(
        title: "3",
        onTap: () {},
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
