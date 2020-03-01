import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class DeveloperCenter extends StatefulWidget {
  DeveloperCenter({Key key}) : super(key: key);

  @override
  _DeveloperCenterState createState() => _DeveloperCenterState();
}

class _DeveloperCenterState extends State<DeveloperCenter>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Developer Center"),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          new TabBar(
            controller: _tabController,
            tabs: [
              new Tab(text: "Shared Preferences"),
              new Tab(text: "SQLite Databases"),
            ],
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                children: [
                  Container(),
                  DatabaseViewer(),
                ],
                controller: _tabController,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DatabaseViewer extends StatefulWidget {
  @override
  _DatabaseViewerState createState() => _DatabaseViewerState();
}

class _DatabaseViewerState extends State<DatabaseViewer>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    _tabController = new TabController(length: tableNames.length, vsync: this);
    super.initState();
  }

  Future<void> resetDatabase() async {
    setState(() {
      isLoading = true;
    });
    tableNames.forEach(
        (table) async => await appDb.database.delete(table).catchError((error) {
              print(error);
            }));
    await appDb.database.execute(teams).catchError((error) {
      print(error);
    });
    await appDb.database.execute(players).catchError((error) {
      print(error);
    });
    await appDb.database.execute(matches).catchError((error) {
      print(error);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: resetDatabase,
        label: Text("Reset Database"),
        icon: isLoading ? CircularProgressIndicator() : Icon(Icons.refresh),
      ),
      body: Column(
        children: <Widget>[
          new TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: tableNames
                .map((name) => new Tab(text: name.toUpperCase()))
                .toList(),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                children: tableNames
                    .map((name) => TableDataList(
                          tableName: name,
                        ))
                    .toList(),
                controller: _tabController,
              ),
            ),
          )
        ],
      ),
    );
  }

  final teams =
      r"INSERT INTO teams(id,name,logo) VALUES (1,'ReliSource',''),(2,'Bangladesh','')";
  final players =
      r"INSERT INTO players(id,first_name,last_name,type,team_id) VALUES (1,'Rahim','Alam',2,1),(2,'Al Amin','Khan',2,1),(3,'Rafiq','Uddin',2,1),(4,'Rabiul','Awal',2,2),(5,'Fahim','Shahrier',2,2),(6,'Salam','Uddin',2,2)";
  final matches =
      """INSERT INTO matches(id,series_id,configuration,teams,players,toss,result) VALUES (1,0,'{"players_per_team":3,"total_overs":8,"per_bowler":3}','{"team_one_id":1,"team_two_id":2}','{"team_one_players":[1,2,3],"team_two_players":[4,5,6]}','{"team_won":1,"decision":"BATTING"}','{"winning_team":null,"win_by":null}')""";
}

class TableDataList extends StatefulWidget {
  final String tableName;
  const TableDataList({
    Key key,
    @required this.tableName,
  }) : super(key: key);

  @override
  _TableDataListState createState() => _TableDataListState();
}

class _TableDataListState extends State<TableDataList> {
  SelectBloc _selectBloc;
  @override
  void initState() {
    super.initState();
    _selectBloc = SelectBloc(database: appDb, table: widget.tableName);
  }

  @override
  void dispose() {
    _selectBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Should Use FutureProvider
    return StreamBuilder<List<Map>>(
      stream: _selectBloc.items,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Items: ${snapshot.data.length}"),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: HighlightView(
                        jsonEncode(snapshot.data[index]),
                        language: 'json',
                        tabSize: 4,
                        theme: githubTheme,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(
                    color: Colors.grey,
                  ),
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
    );
  }
}
