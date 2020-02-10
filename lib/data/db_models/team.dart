import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Team with DbModel {
  @override
  int id;

  final String name;
  final String logo;

  Team({this.id, this.name, this.logo = ""});

  @override
  Db get db => appDb;

  @override
  DbTable get table => teamTable;

  @override
  Map<String, dynamic> toDb() => {"name": name, "logo": logo};

  @override
  DbModel fromDb(Map<String, dynamic> map) => Team(
        id: map['id'] as int,
        name: map['name'] as String,
        logo: map['logo'] as String,
      );
}
