import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Series with DbModel {
  @override
  int id;

  final String name;
  final int totalMatch;

  Series({this.id, this.name, this.totalMatch});

  @override
  Db get db => appDb;

  @override
  DbTable get table => seriesTable;

  @override
  Map<String, dynamic> toDb() => {"name": name, "total_match": totalMatch};

  @override
  DbModel fromDb(Map<String, dynamic> map) => Series(
        id: map['id'] as int,
        name: map['name'] as String,
        totalMatch: map['total_match'] as int,
      );
}
