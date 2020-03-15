import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/services/repository.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/base_viewmodel.dart';

class MatchListViewModel extends BaseViewModel {
  List<Team> teams = new List<Team> ();
  List<Match> matches = new List<Match>();

  Future<bool> getMatches() async {
    teams = await repository.fetchTeams();
    matches = await repository.fetchMatches();
    notifyListeners();
    return true;
  }

  Future<List<Match>> getMatchList(MatchStatus matchStatus) async {
    if(matchStatus == MatchStatus.CURRENT)
      return matches.where((match) => match.result.winBy == null).toList();
    return matches.where((match) => match.result.winBy != null).toList();
  }

  Future<List<Innings>> getMatchInningsBy(matchId) {
    return repository.fetchInnings(matchId);
  }
}