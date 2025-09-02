// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticationResponse _$AuthenticationResponseFromJson(
  Map<String, dynamic> json,
) => _AuthenticationResponse(
  token: json['token'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$AuthenticationResponseToJson(
  _AuthenticationResponse instance,
) => <String, dynamic>{'token': instance.token, 'roles': instance.roles};
