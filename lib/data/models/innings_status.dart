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
  });

  factory InningsStatus.fromJson(String str) =>
      InningsStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InningsStatus.fromMap(Map<String, dynamic> json) => InningsStatus(
        totalRun: json["total_run"] == null ? null : json["total_run"],
        totalWicket: json["total_wicket"] == null ? null : json["total_wicket"],
        totalBall: json["total_ball"] == null ? null : json["total_ball"],
        firstBatsmanId:
            json["first_batsman_id"] == null ? null : json["first_batsman_id"],
        secondBatsmanId: json["second_batsman_id"] == null
            ? null
            : json["second_batsman_id"],
        currentBowlerId: json["current_bowler_id"] == null
            ? null
            : json["current_bowler_id"],
        nextBatsmanPosition: json["next_batsman_position"] == null
            ? null
            : json["next_batsman_position"],
        strikeBatsmanId: json["strike_batsman_id"] == null
            ? null
            : json["strike_batsman_id"],
        currentOverId: json["currentOverId"] == null
            ? null
            : json["currentOverId"],
      );

  Map<String, dynamic> toMap() => {
        "total_run": totalRun == null ? null : totalRun,
        "total_wicket": totalWicket == null ? null : totalWicket,
        "total_ball": totalBall == null ? null : totalBall,
        "first_batsman_id": firstBatsmanId == null ? null : firstBatsmanId,
        "second_batsman_id": secondBatsmanId == null ? null : secondBatsmanId,
        "current_bowler_id": currentBowlerId == null ? null : currentBowlerId,
        "next_batsman_position":
            nextBatsmanPosition == null ? null : nextBatsmanPosition,
        "strike_batsman_id": strikeBatsmanId == null ? null : strikeBatsmanId,
        "currentOverId": currentOverId == null ? null : currentOverId
      };
}
