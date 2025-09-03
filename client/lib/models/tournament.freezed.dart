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
mixin _$Tournament {

 bool get bootstrapped; String get name; int get backupInterval; int get retainBackups; int get endGameTimerLength; int get gameTimerLength; String? get season;
/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentCopyWith<Tournament> get copyWith => _$TournamentCopyWithImpl<Tournament>(this as Tournament, _$identity);

  /// Serializes this Tournament to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tournament&&(identical(other.bootstrapped, bootstrapped) || other.bootstrapped == bootstrapped)&&(identical(other.name, name) || other.name == name)&&(identical(other.backupInterval, backupInterval) || other.backupInterval == backupInterval)&&(identical(other.retainBackups, retainBackups) || other.retainBackups == retainBackups)&&(identical(other.endGameTimerLength, endGameTimerLength) || other.endGameTimerLength == endGameTimerLength)&&(identical(other.gameTimerLength, gameTimerLength) || other.gameTimerLength == gameTimerLength)&&(identical(other.season, season) || other.season == season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bootstrapped,name,backupInterval,retainBackups,endGameTimerLength,gameTimerLength,season);

@override
String toString() {
  return 'Tournament(bootstrapped: $bootstrapped, name: $name, backupInterval: $backupInterval, retainBackups: $retainBackups, endGameTimerLength: $endGameTimerLength, gameTimerLength: $gameTimerLength, season: $season)';
}


}

/// @nodoc
abstract mixin class $TournamentCopyWith<$Res>  {
  factory $TournamentCopyWith(Tournament value, $Res Function(Tournament) _then) = _$TournamentCopyWithImpl;
@useResult
$Res call({
 bool bootstrapped, String name, int backupInterval, int retainBackups, int endGameTimerLength, int gameTimerLength, String? season
});




}
/// @nodoc
class _$TournamentCopyWithImpl<$Res>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._self, this._then);

  final Tournament _self;
  final $Res Function(Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bootstrapped = null,Object? name = null,Object? backupInterval = null,Object? retainBackups = null,Object? endGameTimerLength = null,Object? gameTimerLength = null,Object? season = freezed,}) {
  return _then(_self.copyWith(
bootstrapped: null == bootstrapped ? _self.bootstrapped : bootstrapped // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,backupInterval: null == backupInterval ? _self.backupInterval : backupInterval // ignore: cast_nullable_to_non_nullable
as int,retainBackups: null == retainBackups ? _self.retainBackups : retainBackups // ignore: cast_nullable_to_non_nullable
as int,endGameTimerLength: null == endGameTimerLength ? _self.endGameTimerLength : endGameTimerLength // ignore: cast_nullable_to_non_nullable
as int,gameTimerLength: null == gameTimerLength ? _self.gameTimerLength : gameTimerLength // ignore: cast_nullable_to_non_nullable
as int,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Tournament].
extension TournamentPatterns on Tournament {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tournament value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tournament() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tournament value)  $default,){
final _that = this;
switch (_that) {
case _Tournament():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tournament value)?  $default,){
final _that = this;
switch (_that) {
case _Tournament() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool bootstrapped,  String name,  int backupInterval,  int retainBackups,  int endGameTimerLength,  int gameTimerLength,  String? season)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tournament() when $default != null:
return $default(_that.bootstrapped,_that.name,_that.backupInterval,_that.retainBackups,_that.endGameTimerLength,_that.gameTimerLength,_that.season);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool bootstrapped,  String name,  int backupInterval,  int retainBackups,  int endGameTimerLength,  int gameTimerLength,  String? season)  $default,) {final _that = this;
switch (_that) {
case _Tournament():
return $default(_that.bootstrapped,_that.name,_that.backupInterval,_that.retainBackups,_that.endGameTimerLength,_that.gameTimerLength,_that.season);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool bootstrapped,  String name,  int backupInterval,  int retainBackups,  int endGameTimerLength,  int gameTimerLength,  String? season)?  $default,) {final _that = this;
switch (_that) {
case _Tournament() when $default != null:
return $default(_that.bootstrapped,_that.name,_that.backupInterval,_that.retainBackups,_that.endGameTimerLength,_that.gameTimerLength,_that.season);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tournament implements Tournament {
  const _Tournament({required this.bootstrapped, required this.name, required this.backupInterval, required this.retainBackups, required this.endGameTimerLength, required this.gameTimerLength, this.season});
  factory _Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

@override final  bool bootstrapped;
@override final  String name;
@override final  int backupInterval;
@override final  int retainBackups;
@override final  int endGameTimerLength;
@override final  int gameTimerLength;
@override final  String? season;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentCopyWith<_Tournament> get copyWith => __$TournamentCopyWithImpl<_Tournament>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tournament&&(identical(other.bootstrapped, bootstrapped) || other.bootstrapped == bootstrapped)&&(identical(other.name, name) || other.name == name)&&(identical(other.backupInterval, backupInterval) || other.backupInterval == backupInterval)&&(identical(other.retainBackups, retainBackups) || other.retainBackups == retainBackups)&&(identical(other.endGameTimerLength, endGameTimerLength) || other.endGameTimerLength == endGameTimerLength)&&(identical(other.gameTimerLength, gameTimerLength) || other.gameTimerLength == gameTimerLength)&&(identical(other.season, season) || other.season == season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bootstrapped,name,backupInterval,retainBackups,endGameTimerLength,gameTimerLength,season);

@override
String toString() {
  return 'Tournament(bootstrapped: $bootstrapped, name: $name, backupInterval: $backupInterval, retainBackups: $retainBackups, endGameTimerLength: $endGameTimerLength, gameTimerLength: $gameTimerLength, season: $season)';
}


}

/// @nodoc
abstract mixin class _$TournamentCopyWith<$Res> implements $TournamentCopyWith<$Res> {
  factory _$TournamentCopyWith(_Tournament value, $Res Function(_Tournament) _then) = __$TournamentCopyWithImpl;
@override @useResult
$Res call({
 bool bootstrapped, String name, int backupInterval, int retainBackups, int endGameTimerLength, int gameTimerLength, String? season
});




}
/// @nodoc
class __$TournamentCopyWithImpl<$Res>
    implements _$TournamentCopyWith<$Res> {
  __$TournamentCopyWithImpl(this._self, this._then);

  final _Tournament _self;
  final $Res Function(_Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bootstrapped = null,Object? name = null,Object? backupInterval = null,Object? retainBackups = null,Object? endGameTimerLength = null,Object? gameTimerLength = null,Object? season = freezed,}) {
  return _then(_Tournament(
bootstrapped: null == bootstrapped ? _self.bootstrapped : bootstrapped // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,backupInterval: null == backupInterval ? _self.backupInterval : backupInterval // ignore: cast_nullable_to_non_nullable
as int,retainBackups: null == retainBackups ? _self.retainBackups : retainBackups // ignore: cast_nullable_to_non_nullable
as int,endGameTimerLength: null == endGameTimerLength ? _self.endGameTimerLength : endGameTimerLength // ignore: cast_nullable_to_non_nullable
as int,gameTimerLength: null == gameTimerLength ? _self.gameTimerLength : gameTimerLength // ignore: cast_nullable_to_non_nullable
as int,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
