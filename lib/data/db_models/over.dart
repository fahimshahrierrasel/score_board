import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/data/models/ball_details.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Over with DbModel {
  @override
  int id;

  final int playerId;
  final int inningsId;
  final int number;
  final BallDetails ballDetails;

  Over({
    this.id,
    this.playerId,
    this.inningsId,
    this.number,
    this.ballDetails,
  });

  @override
  Db get db => appDb;

  @override
  DbTable get table => overTable;

  @override
  Map<String, dynamic> toDb() => {
        "player_id": playerId,
        "innings_id": inningsId,
        "number": number,
        "ball_details": ballDetails.toJson(),
      };

  @override
  DbModel fromDb(Map<String, dynamic> map) => Over(
        id: map['id'] as int,
        playerId: map['player_id'] as int,
        inningsId: map['innings_id'] as int,
        ballDetails: BallDetails.fromJson(map['ball_details']),
      );
}
