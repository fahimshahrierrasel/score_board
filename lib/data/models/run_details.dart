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

  factory RunDetails.fromMap(Map<String, dynamic> json) => RunDetails(
        zero: json["zero"],
        one: json["one"],
        two: json["two"],
        three: json["three"],
        four: json["four"],
        five: json["five"],
        six: json["six"],
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
