// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticationResponse {

 String get token; List<String> get roles;
/// Create a copy of AuthenticationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationResponseCopyWith<AuthenticationResponse> get copyWith => _$AuthenticationResponseCopyWithImpl<AuthenticationResponse>(this as AuthenticationResponse, _$identity);

  /// Serializes this AuthenticationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationResponse&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.roles, roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,const DeepCollectionEquality().hash(roles));

@override
String toString() {
  return 'AuthenticationResponse(token: $token, roles: $roles)';
}


}

/// @nodoc
abstract mixin class $AuthenticationResponseCopyWith<$Res>  {
  factory $AuthenticationResponseCopyWith(AuthenticationResponse value, $Res Function(AuthenticationResponse) _then) = _$AuthenticationResponseCopyWithImpl;
@useResult
$Res call({
 String token, List<String> roles
});




}
/// @nodoc
class _$AuthenticationResponseCopyWithImpl<$Res>
    implements $AuthenticationResponseCopyWith<$Res> {
  _$AuthenticationResponseCopyWithImpl(this._self, this._then);

  final AuthenticationResponse _self;
  final $Res Function(AuthenticationResponse) _then;

/// Create a copy of AuthenticationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? roles = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthenticationResponse].
extension AuthenticationResponsePatterns on AuthenticationResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticationResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticationResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticationResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticationResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  List<String> roles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticationResponse() when $default != null:
return $default(_that.token,_that.roles);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  List<String> roles)  $default,) {final _that = this;
switch (_that) {
case _AuthenticationResponse():
return $default(_that.token,_that.roles);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  List<String> roles)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticationResponse() when $default != null:
return $default(_that.token,_that.roles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthenticationResponse implements AuthenticationResponse {
  const _AuthenticationResponse({required this.token, required final  List<String> roles}): _roles = roles;
  factory _AuthenticationResponse.fromJson(Map<String, dynamic> json) => _$AuthenticationResponseFromJson(json);

@override final  String token;
 final  List<String> _roles;
@override List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}


/// Create a copy of AuthenticationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticationResponseCopyWith<_AuthenticationResponse> get copyWith => __$AuthenticationResponseCopyWithImpl<_AuthenticationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticationResponse&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other._roles, _roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,const DeepCollectionEquality().hash(_roles));

@override
String toString() {
  return 'AuthenticationResponse(token: $token, roles: $roles)';
}


}

/// @nodoc
abstract mixin class _$AuthenticationResponseCopyWith<$Res> implements $AuthenticationResponseCopyWith<$Res> {
  factory _$AuthenticationResponseCopyWith(_AuthenticationResponse value, $Res Function(_AuthenticationResponse) _then) = __$AuthenticationResponseCopyWithImpl;
@override @useResult
$Res call({
 String token, List<String> roles
});




}
/// @nodoc
class __$AuthenticationResponseCopyWithImpl<$Res>
    implements _$AuthenticationResponseCopyWith<$Res> {
  __$AuthenticationResponseCopyWithImpl(this._self, this._then);

  final _AuthenticationResponse _self;
  final $Res Function(_AuthenticationResponse) _then;

/// Create a copy of AuthenticationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? roles = null,}) {
  return _then(_AuthenticationResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
