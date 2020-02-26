enum NameType { FIRST, LAST }
enum TeamNo { FIRST, SECOND }
enum TossWinningType { BATTING, FIELDING }
enum MatchStatus { CURRENT, PREVIOUS }

extension on TossWinningType {
  String get value => this.toString().split('.').last;
}

const PLAYER_TYPE = ["Batsman", "Bowler", "All-Rounder"];
const PLAYER_TYPE_ICON = [
  "assets/images/bat.png",
  "assets/images/ball.png",
  "assets/images/all_rounder.png"
];

enum RUN_TYPE { ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX }
enum BALL_TYPE { VALID, WD, NB, LB}

extension on BALL_TYPE {
  String get value => this.toString().split('.').last;
}