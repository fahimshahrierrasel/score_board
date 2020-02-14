import 'package:score_board/data/db_models/db_models.dart';

abstract class Source {
  Future<List<Team>> fetchTeams();
  Future<List<Match>> fetchMatches();
}

abstract class Cache {
  Future<int> insertSeries(Series series);
  Future<int> insertMatch(Match match);
  Future<int> insertTeam(Team team);
  Future<List<int>> insertAllPlayers(List<Player> players);
}