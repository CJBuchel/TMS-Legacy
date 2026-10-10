// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_integrity_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentIntegrityCode {

 Enum get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentIntegrityCode&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TournamentIntegrityCode(field0: $field0)';
}


}

/// @nodoc
class $TournamentIntegrityCodeCopyWith<$Res>  {
$TournamentIntegrityCodeCopyWith(TournamentIntegrityCode _, $Res Function(TournamentIntegrityCode) __);
}


/// Adds pattern-matching-related methods to [TournamentIntegrityCode].
extension TournamentIntegrityCodePatterns on TournamentIntegrityCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TournamentIntegrityCode_Error value)?  error,TResult Function( TournamentIntegrityCode_Warning value)?  warning,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error() when error != null:
return error(_that);case TournamentIntegrityCode_Warning() when warning != null:
return warning(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TournamentIntegrityCode_Error value)  error,required TResult Function( TournamentIntegrityCode_Warning value)  warning,}){
final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error():
return error(_that);case TournamentIntegrityCode_Warning():
return warning(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TournamentIntegrityCode_Error value)?  error,TResult? Function( TournamentIntegrityCode_Warning value)?  warning,}){
final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error() when error != null:
return error(_that);case TournamentIntegrityCode_Warning() when warning != null:
return warning(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TournamentErrorCode field0)?  error,TResult Function( TournamentWarningCode field0)?  warning,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error() when error != null:
return error(_that.field0);case TournamentIntegrityCode_Warning() when warning != null:
return warning(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TournamentErrorCode field0)  error,required TResult Function( TournamentWarningCode field0)  warning,}) {final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error():
return error(_that.field0);case TournamentIntegrityCode_Warning():
return warning(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TournamentErrorCode field0)?  error,TResult? Function( TournamentWarningCode field0)?  warning,}) {final _that = this;
switch (_that) {
case TournamentIntegrityCode_Error() when error != null:
return error(_that.field0);case TournamentIntegrityCode_Warning() when warning != null:
return warning(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class TournamentIntegrityCode_Error extends TournamentIntegrityCode {
  const TournamentIntegrityCode_Error(this.field0): super._();
  

@override final  TournamentErrorCode field0;

/// Create a copy of TournamentIntegrityCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentIntegrityCode_ErrorCopyWith<TournamentIntegrityCode_Error> get copyWith => _$TournamentIntegrityCode_ErrorCopyWithImpl<TournamentIntegrityCode_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentIntegrityCode_Error&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TournamentIntegrityCode.error(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TournamentIntegrityCode_ErrorCopyWith<$Res> implements $TournamentIntegrityCodeCopyWith<$Res> {
  factory $TournamentIntegrityCode_ErrorCopyWith(TournamentIntegrityCode_Error value, $Res Function(TournamentIntegrityCode_Error) _then) = _$TournamentIntegrityCode_ErrorCopyWithImpl;
@useResult
$Res call({
 TournamentErrorCode field0
});




}
/// @nodoc
class _$TournamentIntegrityCode_ErrorCopyWithImpl<$Res>
    implements $TournamentIntegrityCode_ErrorCopyWith<$Res> {
  _$TournamentIntegrityCode_ErrorCopyWithImpl(this._self, this._then);

  final TournamentIntegrityCode_Error _self;
  final $Res Function(TournamentIntegrityCode_Error) _then;

/// Create a copy of TournamentIntegrityCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TournamentIntegrityCode_Error(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TournamentErrorCode,
  ));
}


}

/// @nodoc


class TournamentIntegrityCode_Warning extends TournamentIntegrityCode {
  const TournamentIntegrityCode_Warning(this.field0): super._();
  

@override final  TournamentWarningCode field0;

/// Create a copy of TournamentIntegrityCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentIntegrityCode_WarningCopyWith<TournamentIntegrityCode_Warning> get copyWith => _$TournamentIntegrityCode_WarningCopyWithImpl<TournamentIntegrityCode_Warning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentIntegrityCode_Warning&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'TournamentIntegrityCode.warning(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $TournamentIntegrityCode_WarningCopyWith<$Res> implements $TournamentIntegrityCodeCopyWith<$Res> {
  factory $TournamentIntegrityCode_WarningCopyWith(TournamentIntegrityCode_Warning value, $Res Function(TournamentIntegrityCode_Warning) _then) = _$TournamentIntegrityCode_WarningCopyWithImpl;
@useResult
$Res call({
 TournamentWarningCode field0
});




}
/// @nodoc
class _$TournamentIntegrityCode_WarningCopyWithImpl<$Res>
    implements $TournamentIntegrityCode_WarningCopyWith<$Res> {
  _$TournamentIntegrityCode_WarningCopyWithImpl(this._self, this._then);

  final TournamentIntegrityCode_Warning _self;
  final $Res Function(TournamentIntegrityCode_Warning) _then;

/// Create a copy of TournamentIntegrityCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(TournamentIntegrityCode_Warning(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TournamentWarningCode,
  ));
}


}

// dart format on
