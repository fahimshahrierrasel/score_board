import 'dart:convert';

class RunDetails {
  int zero;
  int one;
  int two;
  int three;
  int four;
  int five;
  int six;

  RunDetails({
    this.zero,
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.six,
  });

  factory RunDetails.fromJson(String str) =>
      RunDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  int calculateRuns() {
    int runs = 0;
    runs += 1 * one;
    runs += 2 * two;
    runs += 3 * three;
    runs += 4 * four;
    runs += 5 * five;
    runs += 6 * six;
    return runs;
  }

  int calculateBalls() {
    try {
      return (zero + one + two + three + four + five + six);
    }catch(error){
      print("error on calculateballs");
      return 0;
    }
  }

  double calculateStrikeRate(){
    if(calculateBalls() > 0)
      return (calculateRuns().toDouble() / calculateBalls().toDouble()) * 100;
    return 0.0;
  }

  factory RunDetails.fromMap(Map<String, dynamic> json) => RunDetails(
        zero: json["zero"] ?? 0,
        one: json["one"] ?? 0,
        two: json["two"] ?? 0,
        three: json["three"] ?? 0,
        four: json["four"] ?? 0,
        five: json["five"] ?? 0,
        six: json["six"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "zero": zero,
        "one": one,
        "two": two,
        "three": three,
        "four": four,
        "five": five,
        "six": six,
      };
}
