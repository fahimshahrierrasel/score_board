import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Player with DbModel {
  @override
  int id;

  final String name;
  final String type;
  final int teamId;

  Player({this.id, this.name, this.type, this.teamId});

  @override
  Db get db => appDb;

  @override
  DbTable get table => playerTable;

  @override
  Map<String, dynamic> toDb() =>
      {"name": name, "type": type, "team_id": teamId};

  @override
  DbModel fromDb(Map<String, dynamic> map) => Player(
        id: map['id'] as int,
        name: map['name'] as String,
        type: map['type'] as String,
        teamId: map['team_id'] as int,
      );
}
