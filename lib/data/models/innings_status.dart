import 'dart:convert';

class InningsStatus {
  int totalRun;
  int totalWicket;
  int totalBall;
  int firstBatsmanId;
  int secondBatsmanId;
  int currentBowlerId;
  int nextBatsmanPosition;
  int strikeBatsmanId;
  int currentOverId;
  int lastOverBowlerId;
  Map<String, int> bowlerOvers;
  List<int> outBatsman;

  InningsStatus({
    this.totalRun = 0,
    this.totalWicket = 0,
    this.totalBall = 0,
    this.firstBatsmanId,
    this.secondBatsmanId,
    this.currentBowlerId,
    this.nextBatsmanPosition,
    this.strikeBatsmanId,
    this.currentOverId,
    this.lastOverBowlerId,
    this.bowlerOvers,
    this.outBatsman,
  });

  factory InningsStatus.fromJson(String str) =>
      InningsStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InningsStatus.fromMap(Map<String, dynamic> json) => InningsStatus(
        totalRun: json["total_run"] ?? 0,
        totalWicket: json["total_wicket"] ?? 0,
        totalBall: json["total_ball"] ?? 0,
        firstBatsmanId: json["first_batsman_id"] ?? 0,
        secondBatsmanId: json["second_batsman_id"] ?? 0,
        currentBowlerId: json["current_bowler_id"] ?? 0,
        nextBatsmanPosition: json["next_batsman_position"] ?? 0,
        strikeBatsmanId: json["strike_batsman_id"] ?? 0,
        currentOverId: json["current_over_id"] ?? 0,
        lastOverBowlerId: json["last_over_bowler_id"] ?? 0,
        bowlerOvers: Map<String, int>.from(json["bowler_overs"]) ?? Map<String, int>(),
        outBatsman: List<int>.from(json['out_batsman']) ?? [],
      );

  Map<String, dynamic> toMap() => {
        "total_run": totalRun ?? 0,
        "total_wicket": totalWicket ?? 0,
        "total_ball": totalBall ?? 0,
        "first_batsman_id": firstBatsmanId ?? 0,
        "second_batsman_id": secondBatsmanId ?? 0,
        "current_bowler_id": currentBowlerId ?? 0,
        "next_batsman_position": nextBatsmanPosition ?? 0,
        "strike_batsman_id": strikeBatsmanId ?? 0,
        "current_over_id": currentOverId ?? 0,
        "last_over_bowler_id": lastOverBowlerId ?? 0,
        "bowler_overs": bowlerOvers ?? Map<String, int>(),
        "out_batsman": outBatsman ?? [],
      };
}
