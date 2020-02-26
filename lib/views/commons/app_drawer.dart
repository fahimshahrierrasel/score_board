import 'package:flutter/material.dart';
import 'package:score_board/views/commons/fade_page_route.dart';
import 'package:score_board/views/screens/developer_center.dart';

final appDrawer = AppDrawer();

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text("Developer Center"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(FadePageRoute(
                  builder: (context) => DeveloperCenter()));
            },
          )
        ],
      ),
    );
  }
}
