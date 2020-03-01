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
