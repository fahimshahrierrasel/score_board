import 'dart:convert';

class BallDetails {
  List<Ball> balls;

  BallDetails({
    this.balls,
  });

  factory BallDetails.fromJson(String str) =>
      BallDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BallDetails.fromMap(Map<String, dynamic> json) => BallDetails(
        balls: List<Ball>.from(json["balls"].map((x) => Ball.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "balls": List<dynamic>.from(balls.map((x) => x.toMap())),
      };
}

class Ball {
  int number;
  int run;
  String ballType;
  bool wicket;

  Ball({
    this.number,
    this.run,
    this.ballType,
    this.wicket,
  });

  factory Ball.fromJson(String str) => Ball.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ball.fromMap(Map<String, dynamic> json) => Ball(
        number: json["number"],
        run: json["run"],
        ballType: json["ball_type"],
        wicket: json["wicket"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "run": run,
        "ball_type": ballType,
        "wicket": wicket,
      };
}
