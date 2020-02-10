import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Innings with DbModel {
  @override
  int id;

  final int matchId;
  final int number;

  Innings({this.id, this.matchId, this.number});

  @override
  Db get db => appDb;

  @override
  DbTable get table => inningsTable;

  @override
  Map<String, dynamic> toDb() => {'match_id': matchId, 'number': number};

  @override
  DbModel fromDb(Map<String, dynamic> map) => Innings(
        id: map['id'] as int,
        matchId: map['match_id'] as int,
        number: map['number'] as int,
      );
}
