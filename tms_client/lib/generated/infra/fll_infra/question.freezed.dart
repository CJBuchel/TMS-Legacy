// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionInput {

 CategoricalQuestion get field0;
/// Create a copy of QuestionInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionInputCopyWith<QuestionInput> get copyWith => _$QuestionInputCopyWithImpl<QuestionInput>(this as QuestionInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionInput&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuestionInput(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuestionInputCopyWith<$Res>  {
  factory $QuestionInputCopyWith(QuestionInput value, $Res Function(QuestionInput) _then) = _$QuestionInputCopyWithImpl;
@useResult
$Res call({
 CategoricalQuestion field0
});




}
/// @nodoc
class _$QuestionInputCopyWithImpl<$Res>
    implements $QuestionInputCopyWith<$Res> {
  _$QuestionInputCopyWithImpl(this._self, this._then);

  final QuestionInput _self;
  final $Res Function(QuestionInput) _then;

/// Create a copy of QuestionInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field0 = null,}) {
  return _then(_self.copyWith(
field0: null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as CategoricalQuestion,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionInput].
extension QuestionInputPatterns on QuestionInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuestionInput_Categorical value)?  categorical,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuestionInput_Categorical() when categorical != null:
return categorical(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuestionInput_Categorical value)  categorical,}){
final _that = this;
switch (_that) {
case QuestionInput_Categorical():
return categorical(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuestionInput_Categorical value)?  categorical,}){
final _that = this;
switch (_that) {
case QuestionInput_Categorical() when categorical != null:
return categorical(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CategoricalQuestion field0)?  categorical,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuestionInput_Categorical() when categorical != null:
return categorical(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CategoricalQuestion field0)  categorical,}) {final _that = this;
switch (_that) {
case QuestionInput_Categorical():
return categorical(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CategoricalQuestion field0)?  categorical,}) {final _that = this;
switch (_that) {
case QuestionInput_Categorical() when categorical != null:
return categorical(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class QuestionInput_Categorical extends QuestionInput {
  const QuestionInput_Categorical(this.field0): super._();
  

@override final  CategoricalQuestion field0;

/// Create a copy of QuestionInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionInput_CategoricalCopyWith<QuestionInput_Categorical> get copyWith => _$QuestionInput_CategoricalCopyWithImpl<QuestionInput_Categorical>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionInput_Categorical&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuestionInput.categorical(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuestionInput_CategoricalCopyWith<$Res> implements $QuestionInputCopyWith<$Res> {
  factory $QuestionInput_CategoricalCopyWith(QuestionInput_Categorical value, $Res Function(QuestionInput_Categorical) _then) = _$QuestionInput_CategoricalCopyWithImpl;
@override @useResult
$Res call({
 CategoricalQuestion field0
});




}
/// @nodoc
class _$QuestionInput_CategoricalCopyWithImpl<$Res>
    implements $QuestionInput_CategoricalCopyWith<$Res> {
  _$QuestionInput_CategoricalCopyWithImpl(this._self, this._then);

  final QuestionInput_Categorical _self;
  final $Res Function(QuestionInput_Categorical) _then;

/// Create a copy of QuestionInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuestionInput_Categorical(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as CategoricalQuestion,
  ));
}


}

// dart format on
