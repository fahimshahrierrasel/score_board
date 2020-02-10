import 'dart:convert';

class MatchTeams {
  int teamOneId;
  int teamTwoId;

  MatchTeams({
    this.teamOneId,
    this.teamTwoId,
  });

  factory MatchTeams.fromJson(String str) => MatchTeams.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchTeams.fromMap(Map<String, dynamic> json) => MatchTeams(
    teamOneId: json["team_one_id"],
    teamTwoId: json["team_two_id"],
  );

  Map<String, dynamic> toMap() => {
    "team_one_id": teamOneId,
    "team_two_id": teamTwoId,
  };
}