// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TournamentResponse {

 String get name;
/// Create a copy of TournamentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentResponseCopyWith<TournamentResponse> get copyWith => _$TournamentResponseCopyWithImpl<TournamentResponse>(this as TournamentResponse, _$identity);

  /// Serializes this TournamentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentResponse&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'TournamentResponse(name: $name)';
}


}

/// @nodoc
abstract mixin class $TournamentResponseCopyWith<$Res>  {
  factory $TournamentResponseCopyWith(TournamentResponse value, $Res Function(TournamentResponse) _then) = _$TournamentResponseCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$TournamentResponseCopyWithImpl<$Res>
    implements $TournamentResponseCopyWith<$Res> {
  _$TournamentResponseCopyWithImpl(this._self, this._then);

  final TournamentResponse _self;
  final $Res Function(TournamentResponse) _then;

/// Create a copy of TournamentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentResponse].
extension TournamentResponsePatterns on TournamentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentResponse value)  $default,){
final _that = this;
switch (_that) {
case _TournamentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentResponse() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _TournamentResponse():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _TournamentResponse() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TournamentResponse implements TournamentResponse {
  const _TournamentResponse({required this.name});
  factory _TournamentResponse.fromJson(Map<String, dynamic> json) => _$TournamentResponseFromJson(json);

@override final  String name;

/// Create a copy of TournamentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentResponseCopyWith<_TournamentResponse> get copyWith => __$TournamentResponseCopyWithImpl<_TournamentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentResponse&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'TournamentResponse(name: $name)';
}


}

/// @nodoc
abstract mixin class _$TournamentResponseCopyWith<$Res> implements $TournamentResponseCopyWith<$Res> {
  factory _$TournamentResponseCopyWith(_TournamentResponse value, $Res Function(_TournamentResponse) _then) = __$TournamentResponseCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$TournamentResponseCopyWithImpl<$Res>
    implements _$TournamentResponseCopyWith<$Res> {
  __$TournamentResponseCopyWithImpl(this._self, this._then);

  final _TournamentResponse _self;
  final $Res Function(_TournamentResponse) _then;

/// Create a copy of TournamentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_TournamentResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
