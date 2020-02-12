import 'package:score_board/viewmodels/base_viewmodel.dart';

enum NameType { FIRST, LAST }
enum TeamNo { FIRST, SECOND }
enum TossWinningType { BATTING, FIELDING }

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

  Future<bool> saveMatchConfig(){

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

  void setTossResult(TeamNo winningTeam, TossWinningType electedType){
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
