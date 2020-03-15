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
  Future<List<Innings>> fetchMatchInnings(int matchId) async {
    final rows = await appDb.select(
        table: inningsTableName, where: "match_id = $matchId");
    final List<Innings> innings = [];
    rows.forEach((row) => innings.add(Innings().fromDb(row)));
    return innings;
  }

  @override
  Future<List<Player>> fetchPlayersByIds(List<int> playerIds) async {
    final ids = playerIds.join(",");
    final rows =
        await appDb.select(table: playerTableName, where: "id in ($ids)");
    final List<Player> players = [];
    rows.forEach((row) => players.add(Player().fromDb(row)));
    return players;
  }

  @override
  Future<List<Player>> fetchPlayersByTeam(int teamId) async {
    final rows =
        await appDb.select(table: playerTableName, where: "team_id = $teamId");
    final List<Player> players = [];
    rows.forEach((row) => players.add(Player().fromDb(row)));
    return players;
  }

  @override
  Future<Batting> fetchBatting(int playerId, int inningsId) async {
    final rows = await appDb.select(
        table: battingTableName,
        where: "player_id = $playerId AND innings_id = $inningsId");

    try {
      return Batting().fromDb(rows[0]);
    } catch (err) {
      print(err);
      return null;
    }
  }

  @override
  Future<Over> fetchOver(int overId) async {
    final rows = await appDb.select(
      table: overTableName,
      where: "id = $overId",
    );
    return Over().fromDb(rows[0]);
  }

  // Cache

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

  Future<void> updateMatch(Match updatedMatch){
    return updatedMatch.sqlUpdate();
  }

  @override
  Future<int> insertSeries(Series series) {
    return series.sqlInsert();
  }

  @override
  Future<int> insertTeam(Team team) {
    return team.sqlInsert();
  }

  @override
  Future<int> insertInnings(Innings innings) {
    return innings.sqlInsert();
  }

  Future<void> updateInnings(Innings updatedInnings) {
    return updatedInnings.sqlUpdate();
  }

  @override
  Future<void> upsertBatting(Batting batting) {
    if (batting.id != null)
      return batting.sqlUpdate();
    else
      return batting.sqlInsert();
  }

  @override
  Future<int> insertOver(Over over) {
      return over.sqlInsert();
  }

  @override
  Future<void> updateOver(Over over){
    return over.sqlUpdate();
  }
}
