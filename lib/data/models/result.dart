import 'dart:convert';

class Result {
  int winningTeam;
  String winBy;

  Result({
    this.winningTeam,
    this.winBy,
  });

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
    winningTeam: json["winning_team"],
    winBy: json["win_by"],
  );

  Map<String, dynamic> toMap() => {
    "winning_team": winningTeam,
    "win_by": winBy,
  };
}
