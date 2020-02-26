import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/data/models/innings_status.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Innings with DbModel {
  @override
  int id;

  final int matchId;
  final int number;
  final int battingTeamId;
  final int bowlingTeamId;
  InningsStatus inningsStatus;

  Innings(
      {this.id,
      this.matchId,
      this.number,
      this.battingTeamId,
      this.bowlingTeamId,
      this.inningsStatus});

  @override
  Db get db => appDb;

  @override
  DbTable get table => inningsTable;

  @override
  Map<String, dynamic> toDb() => {
        'match_id': matchId,
        'number': number,
        'batting_team_id': battingTeamId,
        'bowling_team_id': bowlingTeamId,
        "innings_status": inningsStatus.toJson()
      };

  @override
  DbModel fromDb(Map<String, dynamic> map) => Innings(
        id: map['id'] as int,
        matchId: map['match_id'] as int,
        number: map['number'] as int,
        battingTeamId: map['batting_team_id'] as int,
        bowlingTeamId: map['bowling_team_id'] as int,
        inningsStatus: InningsStatus.fromJson(map["innings_status"]),
      );
}
