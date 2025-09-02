import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

@freezed
abstract class TournamentResponse with _$TournamentResponse {
  const factory TournamentResponse({required String name}) =
      _TournamentResponse;

  factory TournamentResponse.fromJson(Map<String, dynamic> json) =>
      _$TournamentResponseFromJson(json);
}
