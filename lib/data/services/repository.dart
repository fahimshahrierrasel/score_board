import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/services/db_provider.dart';

final repository = Repository();

class Repository {
  final dbProvider = DbProvider();

  Future<List<Team>> fetchTeams() {
    return dbProvider.fetchTeams();
  }

  Future<List<Match>> fetchMatches() {
    return dbProvider.fetchMatches();
  }

  Future<List<Innings>> fetchInnings(int matchId) {
    return dbProvider.fetchMatchInnings(matchId);
  }

  Future<List<Player>> fetchPlayerByIds(List<int> ids){
    return dbProvider.fetchPlayersByIds(ids);
  }

  Future<List<Player>> fetchPlayerByTeam(int teamId){
    return dbProvider.fetchPlayersByTeam(teamId);
  }

  Future<Batting> fetchBatting(int playerId, int inningsId){
    return dbProvider.fetchBatting(playerId, inningsId);
  }

  Future<Over> fetchOver(int overId){
    return dbProvider.fetchOver(overId);
  }

  // Cache
  Future<int> insertTeam(Team team) {
    return dbProvider.insertTeam(team);
  }

  Future<List<int>> insertPlayers(List<Player> players) {
    return dbProvider.insertAllPlayers(players);
  }

  Future<int> insertMatch(Match match) {
    return dbProvider.insertMatch(match);
  }

  Future<List<int>> insertMatchInnings(List<Innings> innings) async {
    List<int> inningsIds = [];
    innings.forEach((inning) async {
      final inningsId = await dbProvider.insertInnings(inning);
      inningsIds.add(inningsId);
    });
    return inningsIds;
  }

  Future<void> updateInnings(Innings updatedInnings) {
    return dbProvider.updateInnings(updatedInnings);
  }

  Future<void> upsertBatting(Batting batting){
    return dbProvider.upsertBatting(batting);
  }

  Future<int> insertOver(Over over){
    return dbProvider.insertOver(over);
  }

  Future<void> updateOver(Over over){
    return dbProvider.updateOver(over);
  }

  Future<void> updateMatch(Match match) {
    return dbProvider.updateMatch(match);
  }
}
