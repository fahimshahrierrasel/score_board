import 'dart:convert';
class MatchPlayer {
  List<int> teamOnePlayers;
  List<int> teamTwoPlayers;

  MatchPlayer({
    this.teamOnePlayers,
    this.teamTwoPlayers,
  });

  factory MatchPlayer.fromJson(String str) => MatchPlayer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchPlayer.fromMap(Map<String, dynamic> json) => MatchPlayer(
    teamOnePlayers: List<int>.from(json["team_one_players"].map((x) => x)),
    teamTwoPlayers: List<int>.from(json["team_two_players"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "team_one_players": List<dynamic>.from(teamOnePlayers.map((x) => x)),
    "team_two_players": List<dynamic>.from(teamTwoPlayers.map((x) => x)),
  };
}
