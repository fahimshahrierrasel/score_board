import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/data/models/models.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Match with DbModel {
  @override
  int id;
  final int seriesId;
  final MatchConfiguration configuration;
  final MatchTeams teams;
  final MatchPlayer players;
  final Toss toss;
  final Result result;

  Match({
    this.id,
    this.seriesId,
    this.configuration,
    this.teams,
    this.players,
    this.toss,
    this.result,
  });

  @override
  Db get db => appDb;

  @override
  DbTable get table => matchTable;

  @override
  Map<String, dynamic> toDb() => {
        'series_id': seriesId,
        'configuration': configuration.toJson(),
        'teams': teams.toJson(),
        "players": players.toJson(),
        'toss': toss.toJson(),
        'result': result.toJson(),
      };

  @override
  DbModel fromDb(Map<String, dynamic> map) => Match(
        id: map['id'] as int,
        seriesId: map['series_id'] as int,
        configuration: MatchConfiguration.fromJson(map['configuration']),
        teams: MatchTeams.fromJson(map['teams']),
        players: MatchPlayer.fromJson(map['players']),
        toss: Toss.fromJson(map['toss']),
        result: Result.fromJson(map['result']),
      );
}
