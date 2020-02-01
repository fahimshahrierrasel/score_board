import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/views/commons/decorations.dart';

class CurrentMatchCard extends StatelessWidget {
  final isMatchRunning;

  const CurrentMatchCard({Key key, this.isMatchRunning = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: generalCardDecoration,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Team A",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isMatchRunning ? Colors.green : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "VS",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Text(
                  "Team B",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("8 Players on Each Team", style: GoogleFonts.montserrat(),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("Total 16 Overs", style: GoogleFonts.montserrat(),),
            ),
          ],
        ),
      ),
    );
  }
}
