import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/db_models/match.dart';
import 'package:score_board/data/db_models/player.dart';
import 'package:score_board/data/db_models/series.dart';
import 'package:score_board/data/db_models/team.dart';
import 'package:score_board/data/services/base_providers.dart';
import 'package:score_board/main.dart';

class DbProvider implements Source, Cache {
  @override
  Future<List<Team>> fetchTeams() async {
    final rows = await appDb.select(table: teamTableName);
    final List<Team> teams = [];
    rows.forEach((row) => teams.add(Team().fromDb(row)));
    return teams;
  }

  @override
  Future<List<Match>> fetchMatches() async {
    final rows = await appDb.select(table: matchTableName);
    final List<Match> matches = [];
    rows.forEach((row) => matches.add(Match().fromDb(row)));
    return matches;
  }

  @override
  Future<List<int>> insertAllPlayers(List<Player> players) async {
    List<Map<String, String>> rows =
        players.map((player) => player.toDb()).toList();
    final rawIds = await appDb.batchInsert(table: playerTableName, rows: rows);
    return rawIds.map((rawId) => rawId as int).toList();
  }

  @override
  Future<int> insertMatch(Match match) {
    return match.sqlInsert();
  }

  @override
  Future<int> insertSeries(Series series) {
    return series.sqlInsert();
  }

  @override
  Future<int> insertTeam(Team team) {
    return team.sqlInsert();
  }
}
