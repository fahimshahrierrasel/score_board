import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/hybrid.dart';
import 'package:flutter_highlight/themes/idea.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/rainbow.dart';
import 'package:flutter_highlight/themes/xcode.dart';
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

  @override
  void initState() {
    _tabController = new TabController(length: tableNames.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
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
