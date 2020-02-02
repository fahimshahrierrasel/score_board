import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_board/views/commons/fade_page_route.dart';
import 'package:score_board/views/screens/team_match.dart';

class CreateMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Match"),
      ),
      body: ListView(
        children: <Widget>[
          NewMatchCard(
            title: "Team Match",
            subTitle: "Cricket match between two team",
            imageString: "assets/images/team_match.jpg",
            onTap: () {
              Navigator.of(context).push(
                  FadePageRoute(builder: (context) => TeamMatch()));
            },
          ),
          NewMatchCard(
            title: "Numbering Match",
            subTitle:
                "Cricket match between certain number of player without any particular team",
            imageString: "assets/images/numbering_match.jpg",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class NewMatchCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageString;
  final Function onTap;

  const NewMatchCard(
      {Key key,
      @required this.title,
      this.subTitle,
      @required this.imageString,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10, left: 10, right: 10),
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(imageString))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
