import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/views/commons/decorations.dart';

class CurrentMatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team A vs Team B"),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new TabBar(
            tabs: [
              Tab(
                text: "Cockpit".toUpperCase(),
              ),
              Tab(
                text: "ScoreCard".toUpperCase(),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              MatchControl(),
              ScoreCard(),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

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
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Batsman",
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "R",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "B",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "4s",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "6s",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "SR",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Fahim Shahrier 🏏",
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "20",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "18",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "1",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "111.11",
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Fahim",
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "20",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "18",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "1",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "111.11",
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: generalCardDecoration,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Bowler",
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "O",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "E",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "R",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "W",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "ECO",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Rasel",
                          )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "3",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "1",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "21",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "7.00",
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      ScoreControl(
        title: "Wicket",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        onTap: () {},
      ),
      ScoreControl(
        icon: Icons.undo,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onTap: () {},
      ),
      ScoreControl(
        title: "WD",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControl(
        title: "NB",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControl(
        title: "LB",
        backgroundColor: Colors.yellow,
        onTap: () {},
      ),
      ScoreControl(
        title: "4",
        backgroundColor: Colors.green,
        onTap: () {},
      ),
      ScoreControl(
        title: "6",
        backgroundColor: Colors.green,
        onTap: () {},
      ),
      ScoreControl(
        title: "0",
        onTap: () {},
      ),
      ScoreControl(
        title: "1",
        onTap: () {},
      ),
      ScoreControl(
        title: "2",
        onTap: () {},
      ),
      ScoreControl(
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

class ScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ScoreControl extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  const ScoreControl(
      {Key key,
      this.title,
      this.icon,
      this.backgroundColor,
      this.textColor,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: scoreControlDecoration.copyWith(color: backgroundColor),
            child: icon != null
                ? Icon(
                    icon,
                    color: textColor,
                  )
                : Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
