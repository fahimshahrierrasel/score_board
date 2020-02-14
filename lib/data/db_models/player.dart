import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Player with DbModel {
  @override
  int id;

  final String firstName;
  final String lastName;
  final int type;
  final int teamId;

  Player({this.id, this.firstName, this.lastName, this.type, this.teamId});

  @override
  Db get db => appDb;

  @override
  DbTable get table => playerTable;

  @override
  Map<String, String> toDb() => {
        "first_name": firstName,
        "last_name": lastName,
        "type": type.toString(),
        "team_id": teamId.toString()
      };

  @override
  DbModel fromDb(Map<String, dynamic> map) => Player(
        id: map['id'] as int,
        firstName: map['first_name'] as String,
        lastName: map['last_name'] as String,
        type: map['type'] as int,
        teamId: map['team_id'] as int,
      );
}
