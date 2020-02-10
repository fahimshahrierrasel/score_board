import 'package:score_board/data/models/match_configuration.dart';
import 'package:score_board/data/models/match_player.dart';
import 'package:score_board/data/models/match_teams.dart';
import 'package:score_board/data/models/result.dart';
import 'package:score_board/data/models/toss.dart';
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
