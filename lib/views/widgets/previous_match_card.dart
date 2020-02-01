import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/views/commons/decorations.dart';

class PreviousMatchCard extends StatelessWidget {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Team A",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "120/10",
                      style: GoogleFonts.oswald(
                          fontSize: 12
                      ),
                    ),
                    Text(
                      "(16/16 Overs)",
                      style: GoogleFonts.oswald(
                          fontSize: 12
                      ),
                    )
                  ],
                )

              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Team B",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "121/4",
                      style: GoogleFonts.oswald(
                          fontSize: 12
                      ),
                    ),
                    Text(
                      "(13.3/16 Overs)",
                      style: GoogleFonts.oswald(
                          fontSize: 12
                      ),
                    )
                  ],
                )

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("Team B won by 6 wickets"),
            ),
          ],
        ),
      ),
    );
  }
}
