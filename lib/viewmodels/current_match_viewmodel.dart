import 'package:score_board/data/db_models/db_models.dart';
import 'package:score_board/data/models/innings_status.dart';
import 'package:score_board/data/models/models.dart';
import 'package:score_board/data/services/repository.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/helpers/extensions.dart';
import 'package:score_board/viewmodels/base_viewmodel.dart';

class CurrentMatchViewModel extends BaseViewModel {
  bool hasError = false;
  String errorMessage = "";
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
  int lastBowlerId = 0;
  Map<String, int> bowlerOvers = Map();
  List<int> outBatsman = [];


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

  Future<void> countRunNBall(RunType runType) async {
    if (firstBatsman == null || secondBatsman == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }
    int run = 0;
    switch (runType) {
      case RunType.ZERO:
        run = 0;
        break;
      case RunType.ONE:
        run = 1;
        break;
      case RunType.TWO:
        run = 2;
        break;
      case RunType.THREE:
        run = 3;
        break;
      case RunType.FOUR:
        run = 4;
        break;
      case RunType.FIVE:
        run = 5;
        break;
      case RunType.SIX:
        run = 6;
        break;
    }
    totalRun = totalRun + run;
    await batsmanRun(runType);
    await overRun(run, BallType.VALID, BallRunType.BAT);
    totalBall = totalBall + 1;
    if (totalBall % 6 == 0) {
      overComplete();
    }
    calculateRunRates();
    await saveInnings();
    notifyListeners();
  }

  Future<void> countExtraRun(
      ExtraType extraType, Map<String, dynamic> additionalRun) async {
    if (firstBatsman == null || secondBatsman == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }
    switch (extraType) {
      case ExtraType.WD:
        totalRun += 1;
        break;
      case ExtraType.NB:
        totalRun += 1;
        break;
      case ExtraType.LB:
        totalBall += 1;
        break;
      case ExtraType.B:
        totalBall += 1;
        break;
    }
    int extraRun = additionalRun[EXTRA_RUN] as int;
    totalRun += extraRun;

    if (additionalRun[EXTRA_RUN_TYPE] == BallRunType.BAT) {
      await batsmanRun(extraRun.getRunType());
    } else {
      await batsmanRun(RunType.ZERO);
      tryBatsmanRotation(extraRun.getRunType());
    }

    BallType ballType = BallType.VALID;

    if (extraType == ExtraType.NB)
      ballType = BallType.NB;
    else if (extraType == ExtraType.WD)
      ballType = BallType.WD;
    else
      ballType = BallType.B;

    await overRun(additionalRun[EXTRA_RUN], ballType,
        (additionalRun[EXTRA_RUN_TYPE] as BallRunType));

    if (totalBall % 6 == 0) {
      overComplete();
    }
    calculateRunRates();
    await saveInnings();
    notifyListeners();
  }

  void overComplete() {
    if(bowlerOvers.containsKey(currentBowler.id.toString())){
      bowlerOvers[currentBowler.id.toString()] = bowlerOvers[currentBowler.id.toString()] + 1;
    }else{
      bowlerOvers[currentBowler.id.toString()] = 1;
    }
    lastBowlerId = currentBowler.id;
    batsmanRotation();
    currentBowler = null;
    currentOver = null;

    // TODO Need to check is this innings complete
  }

  /// It will rotate batsman strike
  /// If you only want to rotate batsman based on run use batsmanRotation
  void batsmanRotation() {
    if (strikeBatsman == firstBatsmanBatting)
      strikeBatsman = secondBatsmanBatting;
    else
      strikeBatsman = firstBatsmanBatting;
  }

  Future<void> overRun(int run, BallType ballType, BallRunType ballRunType,
      {hasWicket = false}) async {
    List<Ball> balls = currentOver.ballDetails.balls;
    balls.add(Ball(
      run: run,
      ballType: ballType.value,
      runType: ballRunType.value,
      wicket: hasWicket,
    ));

    BallDetails ballDetails = BallDetails(balls: balls);

    currentOver.ballDetails = ballDetails;
    await repository.updateOver(currentOver);
  }

  Future<void> batsmanRun(RunType runType) async {
    final runDetails = strikeBatsman.runDetails;
    switch (runType) {
      case RunType.ZERO:
        runDetails.zero = runDetails.zero + 1;
        break;
      case RunType.ONE:
        runDetails.one = runDetails.one + 1;
        break;
      case RunType.TWO:
        runDetails.two = runDetails.two + 1;
        break;
      case RunType.THREE:
        runDetails.three = runDetails.three + 1;
        break;
      case RunType.FOUR:
        runDetails.four = runDetails.four + 1;
        break;
      case RunType.FIVE:
        runDetails.five = runDetails.five + 1;
        break;
      case RunType.SIX:
        runDetails.six = runDetails.six + 1;
        break;
    }
    strikeBatsman.runDetails = runDetails;
    await repository.upsertBatting(strikeBatsman);
    tryBatsmanRotation(runType);
  }

  /// Try to rotate batsman based on RunType.
  /// If you only want to rotate just use batsmanRotation()
  void tryBatsmanRotation(RunType runType) {
    if (runType == RunType.ONE ||
        runType == RunType.THREE ||
        runType == RunType.FIVE) {
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
      firstBatsmanId: firstBatsman != null ? firstBatsman.id : 0,
      secondBatsmanId: secondBatsman != null ? secondBatsman.id : 0,
      currentBowlerId: currentBowler != null ? currentBowler.id : 0,
      strikeBatsmanId: strikeBatsman != null ? strikeBatsman.playerId : 0,
      currentOverId: currentOver != null ? currentOver.id : 0,
      lastOverBowlerId: lastBowlerId,
      bowlerOvers: bowlerOvers,
      outBatsman: outBatsman,
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
      lastBowlerId = inningsStatus.lastOverBowlerId;
      bowlerOvers = inningsStatus.bowlerOvers;
      outBatsman = inningsStatus.outBatsman;

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
      if (firstBatsman != null)
        firstBatsmanBatting =
            await repository.fetchBatting(firstBatsman.id, currentInnings.id);
      if (secondBatsman != null)
        secondBatsmanBatting =
            await repository.fetchBatting(secondBatsman.id, currentInnings.id);
      if (inningsStatus.strikeBatsmanId > 0) {
        if (inningsStatus.strikeBatsmanId == firstBatsman.id)
          strikeBatsman = firstBatsmanBatting;
        else if (inningsStatus.strikeBatsmanId == secondBatsman.id)
          strikeBatsman = secondBatsmanBatting;
      }
      if (inningsStatus.currentOverId > 0) {
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

  Future<void> outABatsman(Map<String, dynamic> outDetails) async {
    WicketInfo wicketInfo = WicketInfo(
        bowlerId: currentBowler.id,
        assistId: outDetails[ASSIST_ID] ?? 0,
        type: outDetails[OUT_TYPE]);
    if (outDetails[OUT_BATSMAN_ID] == 0) {
      outBatsman.add(firstBatsman.id);
      strikeBatsman.wicketInfo = wicketInfo;
      await repository.upsertBatting(strikeBatsman);
      strikeBatsman = null;
      firstBatsmanBatting = null;
      firstBatsman = null;
    } else {
      outBatsman.add(secondBatsman.id);
      secondBatsmanBatting.wicketInfo = wicketInfo;
      await repository.upsertBatting(secondBatsmanBatting);
      secondBatsmanBatting = null;
      secondBatsman = null;
    }
    totalWicket += 1;
    totalBall += 1;
    await overRun(0, BallType.W, BallRunType.BAT, hasWicket: true);
    if (totalBall % 6 == 0) {
      overComplete();
    }
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
