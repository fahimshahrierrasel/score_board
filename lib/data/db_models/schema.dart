import 'package:sqlcool/sqlcool.dart';

final tableNames = [
  teamTableName,
  playerTableName,
  seriesTableName,
  matchTableName,
  inningsTableName,
  battingTableName,
  overTableName,
];

final schema = [
  teamTable,
  playerTable,
  seriesTable,
  matchTable,
  inningsTable,
  battingTable,
  overTable
];

const teamTableName = "teams";
final teamTable = DbTable(teamTableName)
  ..index('id')
  ..varchar('name')
  ..varchar('logo', nullable: true);

const playerTableName = "players";
final playerTable = DbTable(playerTableName)
  ..index('id')
  ..varchar('first_name')
  ..varchar('last_name')
  ..integer('type')
  ..integer('team_id');

const seriesTableName = "series";
final seriesTable = DbTable(seriesTableName)
  ..index('id')
  ..varchar('name')
  ..integer('total_match');

const matchTableName = "matches";
final matchTable = DbTable(matchTableName)
  ..index('id')
  ..integer('series_id')
  ..text('configuration')
  ..varchar('teams')
  ..varchar('players')
  ..varchar("toss")
  ..varchar('result');

const inningsTableName = "innings";
final inningsTable = DbTable(inningsTableName)
  ..index('id')
  ..integer('match_id')
  ..integer("batting_team_id")
  ..integer("bowling_team_id")
  ..integer('number')
  ..boolean("is_complete", defaultValue: false)
  ..varchar("innings_status");

const battingTableName = "battings";
final battingTable = DbTable(battingTableName)
  ..index('id')
  ..integer('player_id')
  ..integer('innings_id')
  ..integer('position')
  ..varchar('run_details')
  ..varchar("wicket_info");

final overTableName = "overs";
final overTable = DbTable(overTableName)
  ..index('id')
  ..integer('player_id')
  ..integer('innings_id')
  ..integer('number')
  ..varchar('ball_details');
