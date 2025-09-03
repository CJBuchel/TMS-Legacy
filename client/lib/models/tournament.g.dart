// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tournament _$TournamentFromJson(Map<String, dynamic> json) => _Tournament(
  bootstrapped: json['bootstrapped'] as bool,
  name: json['name'] as String,
  backupInterval: (json['backupInterval'] as num).toInt(),
  retainBackups: (json['retainBackups'] as num).toInt(),
  endGameTimerLength: (json['endGameTimerLength'] as num).toInt(),
  gameTimerLength: (json['gameTimerLength'] as num).toInt(),
  season: json['season'] as String?,
);

Map<String, dynamic> _$TournamentToJson(_Tournament instance) =>
    <String, dynamic>{
      'bootstrapped': instance.bootstrapped,
      'name': instance.name,
      'backupInterval': instance.backupInterval,
      'retainBackups': instance.retainBackups,
      'endGameTimerLength': instance.endGameTimerLength,
      'gameTimerLength': instance.gameTimerLength,
      'season': instance.season,
    };
