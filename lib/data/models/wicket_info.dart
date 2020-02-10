import 'dart:convert';

class WicketInfo {
  int bowlerId;
  String type;
  String assist;

  WicketInfo({
    this.bowlerId,
    this.type,
    this.assist,
  });

  factory WicketInfo.fromJson(String str) => WicketInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WicketInfo.fromMap(Map<String, dynamic> json) => WicketInfo(
    bowlerId: json["bowler_id"],
    type: json["type"],
    assist: json["assist"],
  );

  Map<String, dynamic> toMap() => {
    "bowler_id": bowlerId,
    "type": type,
    "assist": assist,
  };
}