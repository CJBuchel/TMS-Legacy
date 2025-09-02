import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class AuthenticationResponse with _$AuthenticationResponse {
  const factory AuthenticationResponse({
    required String token,
    required List<String> roles,
  }) = _AuthenticationResponse;

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);
}
