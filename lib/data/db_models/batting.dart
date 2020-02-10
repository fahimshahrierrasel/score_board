import 'package:score_board/data/db_models/schema.dart';
import 'package:score_board/data/models/run_details.dart';
import 'package:score_board/data/models/wicket_info.dart';
import 'package:score_board/main.dart';
import 'package:sqlcool/sqlcool.dart';

class Batting with DbModel {
  @override
  int id;

  final int playerId;
  final int inningsId;
  final int position;
  final RunDetails runDetails;
  final WicketInfo wicketInfo;

  Batting({
    this.id,
    this.playerId,
    this.inningsId,
    this.position,
    this.runDetails,
    this.wicketInfo,
  });

  @override
  Db get db => appDb;

  @override
  DbTable get table => battingTable;

  @override
  Map<String, dynamic> toDb() => {
        "player_id": playerId,
        "innings_id": inningsId,
        "position": position,
        "run_details": runDetails.toJson(),
        'wicket_info': wicketInfo.toJson(),
      };

  @override
  DbModel fromDb(Map<String, dynamic> map) => Batting(
        id: map['id'] as int,
        playerId: map['player_id'] as int,
        inningsId: map['innings_id'] as int,
        position: map['position'] as int,
        runDetails: RunDetails.fromJson(map['run_details']),
        wicketInfo: WicketInfo.fromJson(map['wicket_info']),
      );
}
