enum NameType { FIRST, LAST }
enum TeamNo { FIRST, SECOND }
enum TossWinningType { BATTING, FIELDING }
enum MatchStatus { CURRENT, PREVIOUS }
enum RunType { ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX }
enum BallType { VALID, WD, NB, W, B }
enum ExtraType { WD, NB, LB, B }
enum BallRunType { BAT, BYE }
enum OutType { BOWLED, CAUGHT, LBW, RUN, STUMPED, HIT }

const PLAYER_TYPE = ["Batsman", "Bowler", "All-Rounder"];
const PLAYER_TYPE_ICON = [
  "assets/images/bat.png",
  "assets/images/ball.png",
  "assets/images/all_rounder.png"
];
const EXTRA_RUN_TYPE = "EXTRA_RUN_TYPE";
const EXTRA_RUN = "EXTRA_RUN";
const OUT_TYPE = "OUT_TYPE";
const ASSIST_ID = "ASSIST_ID";
const OUT_BATSMAN_ID = "OUT_BATSMAN_ID";
