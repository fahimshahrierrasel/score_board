import 'package:flutter/material.dart';
import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/views/score_board_app.dart';
import 'package:sqlcool/sqlcool.dart';

final appDb = new Db();

void main() {
  runApp(ScoreBoardApp());
  initDb(appDb);
}

Future<void> initDb(Db db) async {
  final databasePath = "scoreboard.db";
  await db.init(path: databasePath, schema: schema).catchError((error) {
    print("Database Initialization Error: $error");
  });
}
