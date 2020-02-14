import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/services/db_provider.dart';

final repository = Repository();

class Repository {
  final dbProvider = DbProvider();

  Future<List<Team>> fetchTeams() async {
    return dbProvider.fetchTeams();
  }

  Future<List<Match>> fetchMatches() {
    return dbProvider.fetchMatches();
  }

  Future<int> insertTeam(Team team) {
    return dbProvider.insertTeam(team);
  }

  Future<List<int>> insertPlayers(List<Player> players) {
    return dbProvider.insertAllPlayers(players);
  }

  Future<int> insertMatch(Match match) {
    return dbProvider.insertMatch(match);
  }
}
