import 'package:score_board/data/db_models/db_models.dart';

abstract class Source {
  Future<List<Team>> fetchTeams();
  Future<List<Match>> fetchMatches();
  Future<List<Innings>> fetchMatchInnings(int matchId);
  Future<List<Player>> fetchPlayersByTeam(int teamId);
  Future<List<Player>> fetchPlayersByIds(List<int> playerIds);
  Future<Batting> fetchBatting(int playerId, int inningsId);
  Future<Over> fetchOver(int overId);
}

abstract class Cache {
  Future<int> insertSeries(Series series);
  Future<int> insertMatch(Match match);
  Future<int> insertTeam(Team team);
  Future<List<int>> insertAllPlayers(List<Player> players);
  Future<int> insertInnings(Innings innings);
  Future<void> upsertBatting(Batting batting);
  Future<int> insertOver(Over over);
  Future<void> updateOver(Over over);
}