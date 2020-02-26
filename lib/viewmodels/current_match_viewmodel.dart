import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/models/innings_status.dart';
import 'package:score_board/data/models/models.dart';
import 'package:score_board/data/services/repository.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/viewmodels/base_viewmodel.dart';

extension on BALL_TYPE {
  String get value => this.toString().split('.').last;
}

class CurrentMatchViewModel extends BaseViewModel {
  bool isMatchStarted = false;
  Match currentMatch;
  List<Innings> matchInnings;
  List<Player> firstTeamPlayers;
  List<Player> secondTeamPlayers;
  Team firstTeam;
  Team secondTeam;
  Innings currentInnings;
  Player firstBatsman;
  Batting firstBatsmanBatting;
  Player secondBatsman;
  Batting secondBatsmanBatting;
  Player currentBowler;
  Over currentOver;
  int totalBall = 0;
  int totalRun = 0;
  int totalWicket = 0;
  double currentRunRate = 0.0;
  double requiredRunRate = 0.0;
  int nextBatsmanPosition = 1;
  int currentOverNumber = 1;
  Batting strikeBatsman;

  Future<void> getTeamPlayers(int teamId) async {
    List<int> playersIds = [];
    if (teamId == currentMatch.teams.teamOneId) {
      playersIds = currentMatch.players.teamOnePlayers;
    } else {
      playersIds = currentMatch.players.teamTwoPlayers;
    }

    List<Player> players = await repository.fetchPlayerByIds(playersIds);
    if (teamId == currentMatch.teams.teamOneId) {
      firstTeamPlayers = players;
    } else {
      secondTeamPlayers = players;
    }
  }

  Future<void> countRunNBall(RUN_TYPE runType) async {
    //Any Batsman or Bowler Null no run will count show error
    // TODO catch above cases
    int run = 0;
    switch (runType) {
      case RUN_TYPE.ZERO:
        run = 0;
        break;
      case RUN_TYPE.ONE:
        run = 1;
        break;
      case RUN_TYPE.TWO:
        run = 2;
        break;
      case RUN_TYPE.THREE:
        run = 3;
        break;
      case RUN_TYPE.FOUR:
        run = 4;
        break;
      case RUN_TYPE.FIVE:
        run = 5;
        break;
      case RUN_TYPE.SIX:
        run = 6;
        break;
    }
    totalRun = totalRun + run;
    await batsmanRun(runType);
    await overRun(run);
    totalBall = totalBall + 1;
    if (totalBall % 6 == 0) {
      overComplete();
    }
    calculateRunRates();
    await saveInnings();
    notifyListeners();
  }

  void overComplete() {
    batsmanRotation();
    currentBowler = null;
    currentOver = null;
  }

  void batsmanRotation() {
    if (strikeBatsman == firstBatsmanBatting)
      strikeBatsman = secondBatsmanBatting;
    else
      strikeBatsman = firstBatsmanBatting;
  }

  Future<void> overRun(int run) async {
    List<Ball> balls = currentOver.ballDetails.balls;
    balls.add(Ball(run: run, ballType: BALL_TYPE.VALID.value, wicket: false));

    BallDetails ballDetails = BallDetails(balls: balls);

    currentOver.ballDetails = ballDetails;
    await repository.updateOver(currentOver);
  }

  Future<void> batsmanRun(RUN_TYPE runType) async {
    final runDetails = strikeBatsman.runDetails;
    switch (runType) {
      case RUN_TYPE.ZERO:
        runDetails.zero = runDetails.zero + 1;
        break;
      case RUN_TYPE.ONE:
        runDetails.one = runDetails.one + 1;
        break;
      case RUN_TYPE.TWO:
        runDetails.two = runDetails.two + 1;
        break;
      case RUN_TYPE.THREE:
        runDetails.three = runDetails.three + 1;
        break;
      case RUN_TYPE.FOUR:
        runDetails.four = runDetails.four + 1;
        break;
      case RUN_TYPE.FIVE:
        runDetails.five = runDetails.five + 1;
        break;
      case RUN_TYPE.SIX:
        runDetails.six = runDetails.six + 1;
        break;
    }
    strikeBatsman.runDetails = runDetails;
    await repository.upsertBatting(strikeBatsman);
    if (runType == RUN_TYPE.ONE ||
        runType == RUN_TYPE.THREE ||
        runType == RUN_TYPE.FIVE) {
      batsmanRotation();
    }
  }

  Team getTeamById(int teamId) {
    return firstTeam.id == teamId ? firstTeam : secondTeam;
  }

  void setMatchNTeam(Match match, Team firstTeam, Team secondTeam) {
    currentMatch = match;
    this.firstTeam = firstTeam;
    this.secondTeam = secondTeam;
  }

  Future<void> checkMatchStarted() async {
    final innings = await repository.fetchInnings(currentMatch.id);
    if (innings.length < 1) {
      isMatchStarted = false;
    } else {
      matchInnings = innings;
      currentInnings = innings[0];
      isMatchStarted = true;
    }
    notifyListeners();
  }

  Future<void> saveInnings() async {
    final updateInnings = currentInnings;
    final inningsStatus = InningsStatus(
      totalRun: totalRun,
      totalBall: totalBall,
      totalWicket: totalWicket,
      nextBatsmanPosition: nextBatsmanPosition,
      firstBatsmanId: firstBatsman != null ? firstBatsman.id : null,
      secondBatsmanId: secondBatsman != null ? secondBatsman.id : null,
      currentBowlerId: currentBowler != null ? currentBowler.id : null,
      strikeBatsmanId: strikeBatsman != null ? strikeBatsman.playerId : null,
      currentOverId: currentOver != null ? currentOver.id : null,
    );
    updateInnings.inningsStatus = inningsStatus;
    await repository.updateInnings(updateInnings);
  }

  Future<bool> setUpInnings() async {
    try {
      await getTeamPlayers(firstTeam.id);
      await getTeamPlayers(secondTeam.id);

      final inningsStatus = currentInnings.inningsStatus;
      totalRun = inningsStatus.totalRun;
      totalBall = inningsStatus.totalBall;
      totalWicket = inningsStatus.totalWicket;
      nextBatsmanPosition = inningsStatus.nextBatsmanPosition ?? 1;

      if (currentInnings.battingTeamId == firstTeam.id) {
        firstBatsman = firstTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.firstBatsmanId ?? 0,
            orElse: () => null);

        secondBatsman = firstTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.secondBatsmanId ?? 0,
            orElse: () => null);
        currentBowler = secondTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.currentBowlerId ?? 0,
            orElse: () => null);
      } else {
        firstBatsman = secondTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.firstBatsmanId ?? 0,
            orElse: () => null);
        secondBatsman = secondTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.secondBatsmanId ?? 0,
            orElse: () => null);
        currentBowler = firstTeamPlayers.firstWhere(
            (player) => player.id == inningsStatus.currentBowlerId ?? 0,
            orElse: () => null);
      }
      if(firstBatsman != null)
        firstBatsmanBatting = await repository.fetchBatting(firstBatsman.id, currentInnings.id);
      if(secondBatsman != null)
        secondBatsmanBatting = await repository.fetchBatting(secondBatsman.id, currentInnings.id);
      if (inningsStatus.strikeBatsmanId != null) {
        if(inningsStatus.strikeBatsmanId == firstBatsman.id)
          strikeBatsman = firstBatsmanBatting;
        else if(inningsStatus.strikeBatsmanId == secondBatsman.id)
          strikeBatsman = secondBatsmanBatting;
      }
      if(inningsStatus.currentOverId != null){
        currentOver = await repository.fetchOver(inningsStatus.currentOverId);
      }
      calculateRunRates();
      notifyListeners();
    } on NoSuchMethodError catch (error) {
      print(error.stackTrace);
      return false;
    }
    return true;
  }

  Future<bool> createMatchInnings() async {
    int firstBattingTeam = 0;
    int secondBattingTeam = 0;
    if (currentMatch.toss.decision == "BATTING") {
      firstBattingTeam = currentMatch.toss.teamWon;
    } else {
      firstBattingTeam =
          currentMatch.teams.teamOneId == currentMatch.toss.teamWon
              ? currentMatch.teams.teamTwoId
              : currentMatch.teams.teamOneId;
    }
    secondBattingTeam = currentMatch.teams.teamOneId == firstBattingTeam
        ? currentMatch.teams.teamTwoId
        : currentMatch.teams.teamOneId;

    Innings firstInnings = Innings(
      matchId: currentMatch.id,
      number: 1,
      battingTeamId: firstBattingTeam,
      bowlingTeamId: secondBattingTeam,
      inningsStatus: InningsStatus(),
    );

    Innings secondInnings = Innings(
      matchId: currentMatch.id,
      number: 2,
      battingTeamId: secondBattingTeam,
      bowlingTeamId: firstBattingTeam,
      inningsStatus: InningsStatus(),
    );

    final innings = [firstInnings, secondInnings];
    await repository.insertMatchInnings(innings);
    isMatchStarted = true;
    notifyListeners();
    return true;
  }

  Future<void> setBatsman(Player player) async {
    Batting newBatting = Batting(
      playerId: player.id,
      inningsId: currentInnings.id,
      position: nextBatsmanPosition,
      runDetails: RunDetails(),
      wicketInfo: WicketInfo(),
    );
    await repository.upsertBatting(newBatting);
    final batting = await repository.fetchBatting(player.id, currentInnings.id);
    if (firstBatsman == null) {
      firstBatsman = player;
      firstBatsmanBatting = batting;
      strikeBatsman = firstBatsmanBatting;
    } else {
      secondBatsman = player;
      secondBatsmanBatting = batting;
    }
    nextBatsmanPosition = nextBatsmanPosition + 1;
    await saveInnings();
    notifyListeners();
  }

  Future<void> setBowler(Player player) async {
    currentBowler = player;
    Over newOver = Over(
        playerId: player.id,
        inningsId: currentInnings.id,
        number: currentOverNumber,
        ballDetails: BallDetails());
    int overId = await repository.insertOver(newOver);
    currentOver = await repository.fetchOver(overId);
    currentOverNumber = currentOverNumber + 1;
    await saveInnings();
    notifyListeners();
  }

  void calculateRunRates() {
    final overs = (totalBall ~/ 6) == 0 ? 1 : (totalBall ~/ 6);
    currentRunRate = totalRun / overs.toDouble();
  }
}
