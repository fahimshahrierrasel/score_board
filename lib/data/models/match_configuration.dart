import 'dart:convert';

class MatchConfiguration {
  int playersPerTeam;
  int totalOvers;
  int perBowler;

  MatchConfiguration({
    this.playersPerTeam,
    this.totalOvers,
    this.perBowler,
  });

  factory MatchConfiguration.fromJson(String str) => MatchConfiguration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchConfiguration.fromMap(Map<String, dynamic> json) => MatchConfiguration(
    playersPerTeam: json["players_per_team"],
    totalOvers: json["total_overs"],
    perBowler: json["per_bowler"],
  );

  Map<String, dynamic> toMap() => {
    "players_per_team": playersPerTeam,
    "total_overs": totalOvers,
    "per_bowler": perBowler,
  };
}
