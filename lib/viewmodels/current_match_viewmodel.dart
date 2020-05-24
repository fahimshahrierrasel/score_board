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
  int currentOverNumber = 1;
  Batting strikeBatsman;
  UndoOptions undoOptions;

  void resetViewModel() {
    players = [];
    firstBatsmanBatting = null;
    secondBatsmanBatting = null;
    currentBowler = null;
    currentOver = null;
    strikeBatsman = null;
    currentOverNumber = 1;
    undoOptions = UndoOptions();
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
    if (isInningsComplete()) {
      throw Exception("Innings Already Completed");
    }
    if (firstBatsmanBatting == null || secondBatsmanBatting == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }

    // Save undo Option
    saveUndoOption();

    await batsmanRun(runType);
    await overRun(
      run: runType.run(),
      ballType: BallType.VALID,
      ballRunType: BallRunType.BAT,
    );
    calculateBall();
    addRun(runType.run());
    await saveInnings();
    notifyListeners();
  }

  /// Count extra run with [extraType] and [additionalRun] which is run type and run score
  Future<void> countExtraRun(
      ExtraType extraType, Map<String, dynamic> additionalRun) async {
    if (isInningsComplete()) {
      throw Exception("Innings Already Completed");
    }
    if (firstBatsmanBatting == null || secondBatsmanBatting == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }

    // Save undo Option
    saveUndoOption();

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
    print(additionalRun[EXTRA_RUN_TYPE]);
    await overRun(
      run: additionalExtraRun,
      ballType: ballType,
      ballRunType: (additionalRun[EXTRA_RUN_TYPE] as BallRunType),
    );

    extraRun += additionalExtraRun;

    if (ballType == BallType.B) calculateBall();

    addRun(extraRun);
    await saveInnings();
    notifyListeners();
  }

  /// Out a batsman with [outDetails]
  Future<void> outABatsman(Map<String, dynamic> outDetails) async {
    if (isInningsComplete()) {
      throw Exception("Innings Already Completed");
    }

    if (firstBatsmanBatting == null || secondBatsmanBatting == null) {
      throw Exception("Either first or second batsman can not be empty");
    }
    if (currentBowler == null) {
      throw Exception("Bowler can not be empty");
    }

    WicketInfo wicketInfo = WicketInfo(
      bowlerId: currentBowler.id,
      assistId: outDetails[ASSIST_ID] ?? 0,
      type: outDetails[OUT_TYPE],
    );
    List<int> outBatsman = [];
    if (outDetails[OUT_BATSMAN_ID] == 0) {
      outBatsman.add(firstBatsmanBatting.playerId);
      strikeBatsman.wicketInfo = wicketInfo;
      // Save undo Option
      saveUndoOption(outBatsmanId: strikeBatsman.playerId);
      await repository.upsertBatting(strikeBatsman);
      strikeBatsman = null;
      firstBatsmanBatting = null;
    } else {
      outBatsman.add(secondBatsmanBatting.playerId);
      secondBatsmanBatting.wicketInfo = wicketInfo;
      // Save undo Option
      saveUndoOption(outBatsmanId: secondBatsmanBatting.playerId);
      await repository.upsertBatting(secondBatsmanBatting);
      secondBatsmanBatting = null;
    }
    await overRun(
      run: 0,
      ballType: BallType.W,
      ballRunType: BallRunType.BAT,
      hasWicket: true,
    );
    currentInnings.inningsStatus.totalWicket += 1;
    currentInnings.inningsStatus.outBatsman.addAll(outBatsman);
    calculateBall();
    await saveInnings();
    notifyListeners();
  }

  void addRun(int run) {
    currentInnings.inningsStatus.totalRun += run;
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

  /// Update the database for ball's [run], [ballType] and [ballRunType].
  Future<void> overRun(
      {int run = 0,
      BallType ballType = BallType.VALID,
      BallRunType ballRunType = BallRunType.BAT,
      hasWicket = false,
      undo = false}) async {
    if (undo) {
      currentOver.ballDetails.balls.removeLast();
    } else {
      currentOver.ballDetails.balls.add(Ball(
        run: run,
        ballType: ballType.value,
        runType: ballRunType.value,
        wicket: hasWicket,
      ));
    }
    await repository.updateOver(currentOver);
  }

  /// Update the database for batsman [runType]
  Future<void> batsmanRun(RunType runType, {bool undo = false}) async {
    int ball = 1;
    if (undo) ball = -1;
    final runDetails = strikeBatsman.runDetails;
    switch (runType) {
      case RunType.ZERO:
        runDetails.zero += ball;
        break;
      case RunType.ONE:
        runDetails.one += ball;
        break;
      case RunType.TWO:
        runDetails.two += ball;
        break;
      case RunType.THREE:
        runDetails.three += ball;
        break;
      case RunType.FOUR:
        runDetails.four += ball;
        break;
      case RunType.FIVE:
        runDetails.five += ball;
        break;
      case RunType.SIX:
        runDetails.six += ball;
        break;
    }
    strikeBatsman.runDetails = runDetails;
    await repository.upsertBatting(strikeBatsman);
    if (!undo) tryBatsmanRotation(runType);
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

  /// It will rotate batsman strike
  /// If you only want to rotate batsman based on run use [tryBatsmanRotation]
  void batsmanRotation() {
    if (strikeBatsman == firstBatsmanBatting)
      strikeBatsman = secondBatsmanBatting;
    else
      strikeBatsman = firstBatsmanBatting;
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

    await repository.updateInnings(currentInnings);
  }

  Future announceInningsComplete() async {
    currentInnings.isComplete = true;
    await repository.updateInnings(currentInnings);

    if (currentInnings.number == 2) {
      _calculateResult();
    }
  }

  Future _calculateResult() async {
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

  bool isInningsComplete() {
    if (currentInnings.isComplete) return true;

    if (currentInnings.inningsStatus.totalBall ~/ 6 >=
            currentMatch.configuration.totalOvers ||
        currentInnings.inningsStatus.totalWicket >=
            currentMatch.configuration.playersPerTeam - 1) {
      return true;
    }
    if (currentInnings.number == 2 &&
        (currentInnings.inningsStatus.totalRun >
            matchInnings[0].inningsStatus.totalRun)) {
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

  double calculateRunRates(int runs, int balls) {
    final overs = (balls ~/ 6) == 0 ? 1 : (balls ~/ 6);
    return runs / overs.toDouble();
  }

  Future<void> undoLastBall() async {
    // Check undoOptions available
    if (undoOptions == null || undoOptions.hasUndoOnce) {
      throw Exception("Undo option is not ready yet play a ball first!!!");
    }
    // Check if the over is complete
    if (currentOver == null)
      currentOver = await repository.fetchOver(undoOptions.overId);
    Ball lastBall = currentOver.ballDetails.balls.last;
    // Update Over
    await overRun(undo: true);

    if (undoOptions.hasWicket && lastBall.ballType == "W")
      await _undoWicket();
    else if (lastBall.ballType == "VALID")
      _undoValidBall(lastBall);
    else
      _undoExtraBall(lastBall);

    undoOptions.hasUndoOnce = true;
    await saveInnings();
    notifyListeners();
  }

  void _undoExtraBall(Ball lastBall) {
    if (lastBall.ballType == "B") {
      currentInnings.inningsStatus.totalBall -= 1;
    } else {
      // Remove Wide/No-Ball extra run.
      currentInnings.inningsStatus.totalRun -= 1;
    }
    _undoStrikeBatsman();
    // Decrease extra run by batsman/bye
    if (lastBall.runType == "BYE" &&
        (lastBall.ballType == "B" || lastBall.ballType == "NB")) {
      // Batsman will not get the run but ball will count on his name undo this
      batsmanRun(0.getRunType(), undo: true);
    } else if (lastBall.runType == "BAT")
      batsmanRun(lastBall.run.getRunType(), undo: true);
    currentInnings.inningsStatus.totalRun -= lastBall.run;
  }

  void _undoValidBall(Ball lastBall) {
    _undoStrikeBatsman();
    batsmanRun(lastBall.run.getRunType(), undo: true);
    currentInnings.inningsStatus.totalBall -= 1;
    currentInnings.inningsStatus.totalRun -= lastBall.run;
  }

  void _undoStrikeBatsman() {
    if (undoOptions.strikeBatsmanId == firstBatsmanBatting.id)
      strikeBatsman = firstBatsmanBatting;
    else
      strikeBatsman = secondBatsmanBatting;
  }

  Future _undoWicket() async {
    final batting = await repository.fetchBatting(
        undoOptions.outBatsmanId, currentInnings.id);
    batting.wicketInfo = WicketInfo();
    if (firstBatsmanBatting == null)
      firstBatsmanBatting = batting;
    else
      secondBatsmanBatting = batting;
    if (strikeBatsman == null) strikeBatsman = batting;
    repository.upsertBatting(batting);
    currentInnings.inningsStatus.totalWicket -= 1;
    currentInnings.inningsStatus.totalBall -= 1;
  }

  void saveUndoOption({outBatsmanId = 0}) {
    undoOptions.hasUndoOnce = false;
    undoOptions.overId = currentInnings.inningsStatus.currentOverId;
    undoOptions.strikeBatsmanId = strikeBatsman.playerId;
    if (outBatsmanId > 0) {
      undoOptions.hasWicket = true;
      undoOptions.outBatsmanId = outBatsmanId;
    }
  }
}
