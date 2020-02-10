import 'dart:convert';

class Toss {
  int teamWon;
  String decision;

  Toss({
    this.teamWon,
    this.decision,
  });

  factory Toss.fromJson(String str) => Toss.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Toss.fromMap(Map<String, dynamic> json) => Toss(
    teamWon: json["team_won"],
    decision: json["decision"],
  );

  Map<String, dynamic> toMap() => {
    "team_won": teamWon,
    "decision": decision,
  };
}