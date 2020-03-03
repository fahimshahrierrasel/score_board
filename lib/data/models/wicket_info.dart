import 'dart:convert';

class WicketInfo {
  int bowlerId;
  int type;
  int assistId;

  WicketInfo({
    this.bowlerId,
    this.type,
    this.assistId,
  });

  factory WicketInfo.fromJson(String str) => WicketInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WicketInfo.fromMap(Map<String, dynamic> json) => WicketInfo(
    bowlerId: json["bowler_id"],
    type: json["type"],
    assistId: json["assist_by"],
  );

  Map<String, dynamic> toMap() => {
    "bowler_id": bowlerId,
    "type": type,
    "assist_by": assistId,
  };
}