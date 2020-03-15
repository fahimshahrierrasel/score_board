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
  List<Player> players;
  Team firstTeam;
  Team secondTeam;
  Innings currentInnings;
  Batting firstBatsmanBatting;
  Batting secondBatsmanBatting;
  Player currentBowler;
  Over currentOver;
  double currentRunRate = 0.0;
  double requiredRunRate = 0.0;
  int currentOverNumber = 1;
  Batting strikeBatsman;

  void resetViewModel() {
    players = [];
    firstBatsmanBatting = null;
    secondBatsmanBatting = null;
    currentBowler = null;
    currentOver = null;
    strikeBatsman = null;
    currentOverNumber = 1;
  }

  /// Get the players of the team by [teamId]
  Future<void> getTeamPlayers() async {
    List<int> playersIds = [];
    playersIds.addAll(currentMatch.players.teamOnePlayers);
    playersIds.addAll(currentMatch.players.teamTwoPlayers);
    players = await repository.fetchPlayerByIds(playersIds);
  }

  /// Count run and valid ball using the [runType]
  Future<void> countRunNBall(RunType runType) async {
    if (firstBatsmanBatting == null || secondBatsmanBatting == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }
    await batsmanRun(runType);
    await overRun(runType.run(), BallType.VALID, BallRunType.BAT);
    calculateBall();
    addRun(runType.run());
    calculateRunRates();
    await saveInnings();
    notifyListeners();
  }

  void addRun(int run) {
    currentInnings.inningsStatus.totalRun += run;
  }

  /// Count extra run with [extraType] and [additionalRun] which is run type and run score
  Future<void> countExtraRun(
      ExtraType extraType, Map<String, dynamic> additionalRun) async {
    if (firstBatsmanBatting == null || secondBatsmanBatting == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }
    int extraRun = 0;
    BallType ballType = BallType.VALID;

    switch (extraType) {
      case ExtraType.WD:
        ballType = BallType.WD;
        extraRun += 1;
        break;
      case ExtraType.NB:
        ballType = BallType.NB;
        extraRun += 1;
        break;
      case ExtraType.LB:
        ballType = BallType.B;
        break;
      case ExtraType.B:
        ballType = BallType.B;
        break;
    }

    int additionalExtraRun =
        additionalRun[EXTRA_RUN] as int; // Run on extra ball

    if (additionalRun[EXTRA_RUN_TYPE] == BallRunType.BAT) {
      await batsmanRun(additionalExtraRun.getRunType());
    } else {
      // If extra type is other than wide
      // then ball will be count against batsman
      if (extraType != ExtraType.WD) await batsmanRun(RunType.ZERO);
      // For bye run > 0 rotate batsman
      tryBatsmanRotation(additionalExtraRun.getRunType());
    }
    await overRun(additionalExtraRun, ballType,
        (additionalRun[EXTRA_RUN_TYPE] as BallRunType));

    extraRun += additionalExtraRun;

    if (ballType == BallType.B) calculateBall();

    addRun(extraRun);
    calculateRunRates();
    await saveInnings();
    notifyListeners();
  }

  /// call if the over is complete
  void calculateBall() {
    currentInnings.inningsStatus.totalBall += 1;
    if (currentInnings.inningsStatus.totalBall % 6 == 0) {
      if (currentInnings.inningsStatus.bowlerOvers
          .containsKey(currentBowler.id.toString())) {
        currentInnings.inningsStatus.bowlerOvers[currentBowler.id.toString()] =
            currentInnings
                    .inningsStatus.bowlerOvers[currentBowler.id.toString()] +
                1;
      } else {
        currentInnings.inningsStatus.bowlerOvers[currentBowler.id.toString()] =
            1;
      }
      currentInnings.inningsStatus.lastOverBowlerId = currentBowler.id;
      currentBowler = null;
      currentOver = null;
      batsmanRotation();
    }
  }

  /// It will rotate batsman strike
  /// If you only want to rotate batsman based on run use [tryBatsmanRotation]
  void batsmanRotation() {
    if (strikeBatsman == firstBatsmanBatting)
      strikeBatsman = secondBatsmanBatting;
    else
      strikeBatsman = firstBatsmanBatting;
  }

  /// Update the database for ball's [run], [ballType] and [ballRunType].
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

  /// Update the database for batsman [runType]
  Future<void> batsmanRun(RunType runType) async {
    final runDetails = strikeBatsman.runDetails;
    switch (runType) {
      case RunType.ZERO:
        runDetails.zero += 1;
        break;
      case RunType.ONE:
        runDetails.one += 1;
        break;
      case RunType.TWO:
        runDetails.two += 1;
        break;
      case RunType.THREE:
        runDetails.three += 1;
        break;
      case RunType.FOUR:
        runDetails.four += 1;
        break;
      case RunType.FIVE:
        runDetails.five += 1;
        break;
      case RunType.SIX:
        runDetails.six += 1;
        break;
    }
    strikeBatsman.runDetails = runDetails;
    await repository.upsertBatting(strikeBatsman);
    tryBatsmanRotation(runType);
  }

  /// Try to rotate batsman based on RunType.
  /// If you only want to rotate just use [batsmanRotation]
  void tryBatsmanRotation(RunType runType) {
    if (runType == RunType.ONE ||
        runType == RunType.THREE ||
        runType == RunType.FIVE) {
      batsmanRotation();
    }
  }

  /// Get team name by its [teamId]
  Team getTeamById(int teamId) {
    return firstTeam.id == teamId ? firstTeam : secondTeam;
  }

  Player getPlayerById(int playerId) {
    return players.firstWhere((player) => player.id == playerId, orElse: null);
  }

  /// Set up match with [match], [firstTeam] and [secondTeam]
  void setMatchNTeam(Match match, Team firstTeam, Team secondTeam) {
    currentMatch = match;
    this.firstTeam = firstTeam;
    this.secondTeam = secondTeam;
  }

  /// Check if the match is started
  Future<void> checkMatchStarted() async {
    final innings = await repository.fetchInnings(currentMatch.id);
    if (innings.length < 1) {
      isMatchStarted = false;
    } else {
      matchInnings = innings;
      if (innings[0].isComplete)
        currentInnings = innings[1];
      else
        currentInnings = innings[0];
      isMatchStarted = true;
    }
    notifyListeners();
  }

  /// Save match status with [isInningsComplete]
  Future<void> saveInnings() async {
    currentInnings.inningsStatus.firstBatsmanId =
        firstBatsmanBatting != null ? firstBatsmanBatting.playerId : 0;
    currentInnings.inningsStatus.secondBatsmanId =
        secondBatsmanBatting != null ? secondBatsmanBatting.playerId : 0;
    currentInnings.inningsStatus.currentBowlerId =
        currentBowler != null ? currentBowler.id : 0;
    currentInnings.inningsStatus.strikeBatsmanId =
        strikeBatsman != null ? strikeBatsman.playerId : 0;
    currentInnings.inningsStatus.currentOverId =
        currentOver != null ? currentOver.id : 0;

    final inningsComplete = isInningsComplete();
    currentInnings.isComplete = inningsComplete;
    await repository.updateInnings(currentInnings);

    if (inningsComplete && currentInnings.number == 2) {
      int winBy = matchInnings[0].inningsStatus.totalRun -
          currentInnings.inningsStatus.totalRun;
      if (winBy > 0) {
        currentMatch.result.winningTeam = currentInnings.bowlingTeamId;
        currentMatch.result.winBy = "$winBy runs";
      } else {
        int wicketRemaining = currentMatch.configuration.playersPerTeam -
            currentInnings.inningsStatus.totalWicket -
            1;
        currentMatch.result.winningTeam = currentInnings.battingTeamId;
        currentMatch.result.winBy = "$wicketRemaining wickets";
      }
      await repository.updateMatch(currentMatch);
    }
  }

  bool isInningsComplete() {
    if (currentInnings.inningsStatus.totalBall ~/ 6 >=
            currentMatch.configuration.totalOvers ||
        currentInnings.inningsStatus.totalWicket >=
            currentMatch.configuration.playersPerTeam - 1) {
      return true;
    }
    if (currentInnings.number == 2 &&
        currentInnings.inningsStatus.totalRun >
            matchInnings[0].inningsStatus.totalRun) {
      return true;
    }

    return false;
  }

  /// Set up innings status for match controlling
  Future<bool> setUpInnings() async {
    try {
      resetViewModel();
      await getTeamPlayers();

      final inningsStatus = currentInnings.inningsStatus;

      if (currentInnings.battingTeamId == firstTeam.id) {
        currentBowler = players.firstWhere(
            (player) => player.id == inningsStatus.currentBowlerId ?? 0,
            orElse: () => null);
      } else {
        currentBowler = players.firstWhere(
            (player) => player.id == inningsStatus.currentBowlerId ?? 0,
            orElse: () => null);
      }
      if (inningsStatus.firstBatsmanId > 0)
        firstBatsmanBatting = await repository.fetchBatting(
            inningsStatus.firstBatsmanId, currentInnings.id);
      if (inningsStatus.secondBatsmanId > 0)
        secondBatsmanBatting = await repository.fetchBatting(
            inningsStatus.secondBatsmanId, currentInnings.id);
      if (inningsStatus.strikeBatsmanId > 0) {
        if (inningsStatus.strikeBatsmanId == inningsStatus.firstBatsmanId)
          strikeBatsman = firstBatsmanBatting;
        else if (inningsStatus.strikeBatsmanId == inningsStatus.secondBatsmanId)
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

  /// Creating match innings for the first time if it is not already created
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
      isComplete: false,
      inningsStatus: InningsStatus(),
    );

    Innings secondInnings = Innings(
      matchId: currentMatch.id,
      number: 2,
      battingTeamId: secondBattingTeam,
      bowlingTeamId: firstBattingTeam,
      isComplete: false,
      inningsStatus: InningsStatus(),
    );

    final innings = [firstInnings, secondInnings];
    await repository.insertMatchInnings(innings);
    isMatchStarted = true;
    notifyListeners();
    return true;
  }

  /// Set and create batting for [player]
  Future<void> setBatsman(Player player) async {
    Batting newBatting = Batting(
      playerId: player.id,
      inningsId: currentInnings.id,
      position: currentInnings.inningsStatus.nextBatsmanPosition,
      runDetails: RunDetails(),
      wicketInfo: WicketInfo(),
    );
    await repository.upsertBatting(newBatting);
    final batting = await repository.fetchBatting(player.id, currentInnings.id);
    if (firstBatsmanBatting == null) {
      firstBatsmanBatting = batting;
      strikeBatsman = firstBatsmanBatting;
    } else {
      secondBatsmanBatting = batting;
    }
    currentInnings.inningsStatus.nextBatsmanPosition += 1;
    await saveInnings();
    notifyListeners();
  }

  Future<void> outABatsman(Map<String, dynamic> outDetails) async {
    WicketInfo wicketInfo = WicketInfo(
      bowlerId: currentBowler.id,
      assistId: outDetails[ASSIST_ID] ?? 0,
      type: outDetails[OUT_TYPE],
    );
    List<int> outBatsman = [];
    if (outDetails[OUT_BATSMAN_ID] == 0) {
      outBatsman.add(firstBatsmanBatting.playerId);
      strikeBatsman.wicketInfo = wicketInfo;
      await repository.upsertBatting(strikeBatsman);
      strikeBatsman = null;
      firstBatsmanBatting = null;
    } else {
      outBatsman.add(secondBatsmanBatting.playerId);
      secondBatsmanBatting.wicketInfo = wicketInfo;
      await repository.upsertBatting(secondBatsmanBatting);
      secondBatsmanBatting = null;
    }
    await overRun(0, BallType.W, BallRunType.BAT, hasWicket: true);
    currentInnings.inningsStatus.totalWicket += 1;
    currentInnings.inningsStatus.outBatsman.addAll(outBatsman);
    calculateBall();
    await saveInnings();
    notifyListeners();
  }

  List<int> getDisableBatsman() {
    List<int> disableBatsman = [];
    if (firstBatsmanBatting != null)
      disableBatsman.add(firstBatsmanBatting.playerId);
    if (secondBatsmanBatting != null)
      disableBatsman.add(secondBatsmanBatting.playerId);
    disableBatsman.addAll(currentInnings.inningsStatus.outBatsman);
    return disableBatsman;
  }

  List<int> getDisableBowler() {
    List<int> disableBowler = [];
    final bowlerOver = currentInnings.inningsStatus.bowlerOvers;
    bowlerOver.forEach((bowlerId, totalOver) {
      if (totalOver >= currentMatch.configuration.perBowler) {
        disableBowler.add(int.parse(bowlerId));
      }
    });
    disableBowler.add(currentInnings.inningsStatus.lastOverBowlerId);
    // Could have same id twice for the above condition
    return disableBowler;
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
    final overs = (currentInnings.inningsStatus.totalBall ~/ 6) == 0
        ? 1
        : (currentInnings.inningsStatus.totalBall ~/ 6);
    currentRunRate = currentInnings.inningsStatus.totalRun / overs.toDouble();
  }
}
