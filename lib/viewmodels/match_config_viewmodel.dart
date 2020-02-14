import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/models/models.dart';
import 'package:score_board/data/services/repository.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/base_viewmodel.dart';
import 'package:score_board/viewmodels/view_state.dart';

extension on TossWinningType {
  String get value => this.toString().split('.').last;
}

class MatchConfigViewModel extends BaseViewModel {
  String firstTeamName;
  String secondTeamName;
  int numberOfPlayer = 7;
  int numberOfOvers = 12;
  int maxOverPerBowler = 3;
  List<String> firstTeamFirstName;
  List<String> firstTeamLastName;
  List<String> secondTeamFirstName;
  List<String> secondTeamLastName;
  List<int> firstTeamPlayerType;
  List<int> secondTeamPlayerType;
  TeamNo tossWinningTeam;
  TossWinningType tossWinnerElectedType;

  Future<bool> saveMatchConfig() async {
    setViewState(ViewState.Busy);

    final matchConfiguration = MatchConfiguration(
        playersPerTeam: numberOfPlayer,
        totalOvers: numberOfOvers,
        perBowler: maxOverPerBowler);

    final firstTeam = Team(
      name: firstTeamName,
    );

    final secondTeam = Team(
      name: secondTeamName,
    );

    final firstTeamId = await repository.insertTeam(firstTeam);
    final secondTeamId = await repository.insertTeam(secondTeam);

    final matchTeams = MatchTeams(
      teamOneId: firstTeamId,
      teamTwoId: secondTeamId,
    );

    final List<Player> firstTeamPlayers = new List<Player>();
    final List<Player> secondTeamPlayers = new List<Player>();

    for (int i = 0; i < numberOfPlayer; i++) {
      firstTeamPlayers.add(Player(
        firstName: firstTeamFirstName[i],
        lastName: firstTeamLastName[i],
        type: firstTeamPlayerType[i],
        teamId: firstTeamId,
      ));

      secondTeamPlayers.add(Player(
        firstName: secondTeamFirstName[i],
        lastName: secondTeamLastName[i],
        type: secondTeamPlayerType[i],
        teamId: secondTeamId,
      ));
    }

    final firstTeamPlayersId = await repository.insertPlayers(firstTeamPlayers);
    final secondTeamPlayersId =
        await repository.insertPlayers(secondTeamPlayers);

    final MatchPlayer matchPlayers = MatchPlayer(
      teamOnePlayers: firstTeamPlayersId,
      teamTwoPlayers: secondTeamPlayersId,
    );

    final toss = Toss(
        teamWon: tossWinningTeam == TeamNo.FIRST ? firstTeamId : secondTeamId,
        decision: tossWinnerElectedType.value);

    final match = Match(
      seriesId: 0,
      configuration: matchConfiguration,
      teams: matchTeams,
      players: matchPlayers,
      toss: toss,
      result: Result(),
    );

    return repository.insertMatch(match).then((matchId) {
      setViewState(ViewState.Idle);
      if (matchId > 0)
        return true;
      else
        return false;
    });
  }

  void changeNumberOfPlayer(double newValue) {
    numberOfPlayer = newValue.toInt();
    notifyListeners();
  }

  void setSizeOfTeamInfo() {
    firstTeamFirstName = new List(numberOfPlayer);
    firstTeamLastName = new List(numberOfPlayer);
    secondTeamFirstName = new List(numberOfPlayer);
    secondTeamLastName = new List(numberOfPlayer);
    firstTeamPlayerType = new List(numberOfPlayer);
    secondTeamPlayerType = new List(numberOfPlayer);
    notifyListeners();
  }

  void setTossResult(TeamNo winningTeam, TossWinningType electedType) {
    tossWinningTeam = winningTeam;
    tossWinnerElectedType = electedType;
    notifyListeners();
  }

  void changeNumberOfOver(double newValue) {
    numberOfOvers = newValue.toInt();
    notifyListeners();
  }

  void changeTeamName(String newValue, int teamNumber) {
    if (teamNumber == 1) {
      firstTeamName = newValue;
    } else {
      secondTeamName = newValue;
    }
    notifyListeners();
  }

  void changePlayerName(
      String newName, NameType nameType, TeamNo teamNo, int index) {
    if (teamNo == TeamNo.FIRST) {
      if (nameType == NameType.FIRST)
        firstTeamFirstName[index] = newName;
      else
        firstTeamLastName[index] = newName;
    } else {
      if (nameType == NameType.FIRST)
        secondTeamFirstName[index] = newName;
      else
        secondTeamLastName[index] = newName;
    }
    notifyListeners();
  }

  void changePlayerType(int type, TeamNo teamNo, int index) {
    if (teamNo == TeamNo.FIRST)
      firstTeamPlayerType[index] = type;
    else
      secondTeamPlayerType[index] = type;
    notifyListeners();
  }

  void reset() {
    firstTeamName = null;
    secondTeamName = null;
    tossWinningTeam = null;
    tossWinnerElectedType = null;
    numberOfPlayer = 7;
    numberOfOvers = 12;
    maxOverPerBowler = 3;
  }
}
