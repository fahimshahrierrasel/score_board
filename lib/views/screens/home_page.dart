import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_board/views/commons/app_drawer.dart';
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
        title: Text("Score Board", style: GoogleFonts.montserrat(),),
      ),
      drawer: appDrawer,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
      body: HomePageTabs(),
    );
  }
}