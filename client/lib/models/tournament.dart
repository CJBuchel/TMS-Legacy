import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

@freezed
abstract class Tournament with _$Tournament {
  const factory Tournament({
    required bool bootstrapped,
    required String name,
    required int backupInterval,
    required int retainBackups,
    required int endGameTimerLength,
    required int gameTimerLength,
    String? season,
  }) = _Tournament;

  // default
  factory Tournament.defaultTournament() {
    return Tournament(
      bootstrapped: false,
      name: "No Tournament Connected",
      backupInterval: 0,
      retainBackups: 0,
      endGameTimerLength: 0,
      gameTimerLength: 0,
    );
  }

  factory Tournament.fromJson(Map<String, dynamic> json) =>
      _$TournamentFromJson(json);
}
