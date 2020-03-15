import 'constants.dart';

extension TossWinningTypeValue on TossWinningType {
  String get value => this.toString().split('.').last;
}

extension BallTypeValue on BallType {
  String get value => this.toString().split('.').last;
}

extension BallRunTypeValue on BallRunType {
  String get value => this.toString().split('.').last;
}

extension OutTypeValue on OutType {
  String get value => this.toString().split('.').last;
}

extension RunFromRunType on RunType {
  int run(){
    switch (this) {
      case RunType.ZERO:
        return 0;
      case RunType.ONE:
        return 1;
      case RunType.TWO:
        return 2;
      case RunType.THREE:
        return 3;
      case RunType.FOUR:
        return 4;
      case RunType.FIVE:
        return 5;
      case RunType.SIX:
        return 6;
    }
    return 0;
  }
}

extension RunTypeFromRun on int {
  RunType getRunType() {
    switch (this) {
      case 0:
        return RunType.ZERO;
      case 1:
        return RunType.ONE;
      case 2:
        return RunType.TWO;
      case 3:
        return RunType.THREE;
      case 4:
        return RunType.FOUR;
      case 5:
        return RunType.FIVE;
      case 6:
        return RunType.SIX;
    }
    return RunType.ZERO;
  }
}

extension OverFromBall on int {
  String getOver() {
    return "${(this / 6).floor()}${this % 6 > 0 ? "." : ""}${this % 6 > 0 ? (this % 6) : ""} Overs";
  }
}
