// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportEventCopyWith<$Res> {
  factory $ReportEventCopyWith(
          ReportEvent value, $Res Function(ReportEvent) then) =
      _$ReportEventCopyWithImpl<$Res, ReportEvent>;
}

/// @nodoc
class _$ReportEventCopyWithImpl<$Res, $Val extends ReportEvent>
    implements $ReportEventCopyWith<$Res> {
  _$ReportEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GenerateImplCopyWith<$Res> {
  factory _$$GenerateImplCopyWith(
          _$GenerateImpl value, $Res Function(_$GenerateImpl) then) =
      __$$GenerateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String userId,
      DateTime startDate,
      DateTime endDate,
      String? categoryId});
}

/// @nodoc
class __$$GenerateImplCopyWithImpl<$Res>
    extends _$ReportEventCopyWithImpl<$Res, _$GenerateImpl>
    implements _$$GenerateImplCopyWith<$Res> {
  __$$GenerateImplCopyWithImpl(
      _$GenerateImpl _value, $Res Function(_$GenerateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? categoryId = freezed,
  }) {
    return _then(_$GenerateImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
class _$GenerateImpl implements _Generate {
  const _$GenerateImpl(
      {required this.userId,
      required this.startDate,
      required this.endDate,
      this.categoryId});

  @override
  final String userId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? categoryId;

  @override
  String toString() {
    return 'ReportEvent.generate(userId: $userId, startDate: $startDate, endDate: $endDate, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, startDate, endDate, categoryId);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateImplCopyWith<_$GenerateImpl> get copyWith =>
      __$$GenerateImplCopyWithImpl<_$GenerateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) {
    return generate(userId, startDate, endDate, categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) {
    return generate?.call(userId, startDate, endDate, categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) {
    if (generate != null) {
      return generate(userId, startDate, endDate, categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) {
    return generate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) {
    return generate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (generate != null) {
      return generate(this);
    }
    return orElse();
  }
}

abstract class _Generate implements ReportEvent {
  const factory _Generate(
      {required final String userId,
      required final DateTime startDate,
      required final DateTime endDate,
      final String? categoryId}) = _$GenerateImpl;

  String get userId;
  DateTime get startDate;
  DateTime get endDate;
  String? get categoryId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateImplCopyWith<_$GenerateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExportImplCopyWith<$Res> {
  factory _$$ExportImplCopyWith(
          _$ExportImpl value, $Res Function(_$ExportImpl) then) =
      __$$ExportImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExpenseReport report});
}

/// @nodoc
class __$$ExportImplCopyWithImpl<$Res>
    extends _$ReportEventCopyWithImpl<$Res, _$ExportImpl>
    implements _$$ExportImplCopyWith<$Res> {
  __$$ExportImplCopyWithImpl(
      _$ExportImpl _value, $Res Function(_$ExportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? report = null,
  }) {
    return _then(_$ExportImpl(
      report: null == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as ExpenseReport,
    ));
  }
}

/// @nodoc
class _$ExportImpl implements _Export {
  const _$ExportImpl({required this.report});

  @override
  final ExpenseReport report;

  @override
  String toString() {
    return 'ReportEvent.export(report: $report)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportImpl &&
            (identical(other.report, report) || other.report == report));
  }

  @override
  int get hashCode => Object.hash(runtimeType, report);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportImplCopyWith<_$ExportImpl> get copyWith =>
      __$$ExportImplCopyWithImpl<_$ExportImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) {
    return export(report);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) {
    return export?.call(report);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) {
    if (export != null) {
      return export(report);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) {
    return export(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) {
    return export?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (export != null) {
      return export(this);
    }
    return orElse();
  }
}

abstract class _Export implements ReportEvent {
  const factory _Export({required final ExpenseReport report}) = _$ExportImpl;

  ExpenseReport get report;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportImplCopyWith<_$ExportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadSavedImplCopyWith<$Res> {
  factory _$$LoadSavedImplCopyWith(
          _$LoadSavedImpl value, $Res Function(_$LoadSavedImpl) then) =
      __$$LoadSavedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$LoadSavedImplCopyWithImpl<$Res>
    extends _$ReportEventCopyWithImpl<$Res, _$LoadSavedImpl>
    implements _$$LoadSavedImplCopyWith<$Res> {
  __$$LoadSavedImplCopyWithImpl(
      _$LoadSavedImpl _value, $Res Function(_$LoadSavedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$LoadSavedImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$LoadSavedImpl implements _LoadSaved {
  const _$LoadSavedImpl({required this.userId});

  @override
  final String userId;

  @override
  String toString() {
    return 'ReportEvent.loadSaved(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadSavedImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadSavedImplCopyWith<_$LoadSavedImpl> get copyWith =>
      __$$LoadSavedImplCopyWithImpl<_$LoadSavedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) {
    return loadSaved(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) {
    return loadSaved?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) {
    if (loadSaved != null) {
      return loadSaved(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) {
    return loadSaved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) {
    return loadSaved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (loadSaved != null) {
      return loadSaved(this);
    }
    return orElse();
  }
}

abstract class _LoadSaved implements ReportEvent {
  const factory _LoadSaved({required final String userId}) = _$LoadSavedImpl;

  String get userId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadSavedImplCopyWith<_$LoadSavedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveImplCopyWith<$Res> {
  factory _$$SaveImplCopyWith(
          _$SaveImpl value, $Res Function(_$SaveImpl) then) =
      __$$SaveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExpenseReport report});
}

/// @nodoc
class __$$SaveImplCopyWithImpl<$Res>
    extends _$ReportEventCopyWithImpl<$Res, _$SaveImpl>
    implements _$$SaveImplCopyWith<$Res> {
  __$$SaveImplCopyWithImpl(
      _$SaveImpl _value, $Res Function(_$SaveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? report = null,
  }) {
    return _then(_$SaveImpl(
      report: null == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as ExpenseReport,
    ));
  }
}

/// @nodoc
class _$SaveImpl implements _Save {
  const _$SaveImpl({required this.report});

  @override
  final ExpenseReport report;

  @override
  String toString() {
    return 'ReportEvent.save(report: $report)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveImpl &&
            (identical(other.report, report) || other.report == report));
  }

  @override
  int get hashCode => Object.hash(runtimeType, report);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveImplCopyWith<_$SaveImpl> get copyWith =>
      __$$SaveImplCopyWithImpl<_$SaveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) {
    return save(report);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) {
    return save?.call(report);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save(report);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) {
    return save(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) {
    return save?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save(this);
    }
    return orElse();
  }
}

abstract class _Save implements ReportEvent {
  const factory _Save({required final ExpenseReport report}) = _$SaveImpl;

  ExpenseReport get report;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveImplCopyWith<_$SaveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteImplCopyWith<$Res> {
  factory _$$DeleteImplCopyWith(
          _$DeleteImpl value, $Res Function(_$DeleteImpl) then) =
      __$$DeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reportId});
}

/// @nodoc
class __$$DeleteImplCopyWithImpl<$Res>
    extends _$ReportEventCopyWithImpl<$Res, _$DeleteImpl>
    implements _$$DeleteImplCopyWith<$Res> {
  __$$DeleteImplCopyWithImpl(
      _$DeleteImpl _value, $Res Function(_$DeleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
  }) {
    return _then(_$DeleteImpl(
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$DeleteImpl implements _Delete {
  const _$DeleteImpl({required this.reportId});

  @override
  final String reportId;

  @override
  String toString() {
    return 'ReportEvent.delete(reportId: $reportId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteImpl &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reportId);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      __$$DeleteImplCopyWithImpl<_$DeleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId, DateTime startDate,
            DateTime endDate, String? categoryId)
        generate,
    required TResult Function(ExpenseReport report) export,
    required TResult Function(String userId) loadSaved,
    required TResult Function(ExpenseReport report) save,
    required TResult Function(String reportId) delete,
  }) {
    return delete(reportId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult? Function(ExpenseReport report)? export,
    TResult? Function(String userId)? loadSaved,
    TResult? Function(ExpenseReport report)? save,
    TResult? Function(String reportId)? delete,
  }) {
    return delete?.call(reportId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId, DateTime startDate, DateTime endDate,
            String? categoryId)?
        generate,
    TResult Function(ExpenseReport report)? export,
    TResult Function(String userId)? loadSaved,
    TResult Function(ExpenseReport report)? save,
    TResult Function(String reportId)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(reportId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Generate value) generate,
    required TResult Function(_Export value) export,
    required TResult Function(_LoadSaved value) loadSaved,
    required TResult Function(_Save value) save,
    required TResult Function(_Delete value) delete,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Generate value)? generate,
    TResult? Function(_Export value)? export,
    TResult? Function(_LoadSaved value)? loadSaved,
    TResult? Function(_Save value)? save,
    TResult? Function(_Delete value)? delete,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Generate value)? generate,
    TResult Function(_Export value)? export,
    TResult Function(_LoadSaved value)? loadSaved,
    TResult Function(_Save value)? save,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _Delete implements ReportEvent {
  const factory _Delete({required final String reportId}) = _$DeleteImpl;

  String get reportId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReportState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportStateCopyWith<$Res> {
  factory $ReportStateCopyWith(
          ReportState value, $Res Function(ReportState) then) =
      _$ReportStateCopyWithImpl<$Res, ReportState>;
}

/// @nodoc
class _$ReportStateCopyWithImpl<$Res, $Val extends ReportState>
    implements $ReportStateCopyWith<$Res> {
  _$ReportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

// ── _Initial ──────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc
class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() => 'ReportState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$InitialImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      initial();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      initial?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) return initial();
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      initial(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      initial?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) return initial(this);
    return orElse();
  }
}

abstract class _Initial implements ReportState {
  const factory _Initial() = _$InitialImpl;
}

// ── _Loading ──────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() => 'ReportState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$LoadingImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      loading();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      loading?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) return loading();
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      loading(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      loading?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) return loading(this);
    return orElse();
  }
}

abstract class _Loading implements ReportState {
  const factory _Loading() = _$LoadingImpl;
}

// ── _Generated ────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$GeneratedImplCopyWith<$Res> {
  factory _$$GeneratedImplCopyWith(
          _$GeneratedImpl value, $Res Function(_$GeneratedImpl) then) =
      __$$GeneratedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExpenseReport report});
}

/// @nodoc
class __$$GeneratedImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$GeneratedImpl>
    implements _$$GeneratedImplCopyWith<$Res> {
  __$$GeneratedImplCopyWithImpl(
      _$GeneratedImpl _value, $Res Function(_$GeneratedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? report = null}) {
    return _then(_$GeneratedImpl(
      report: null == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as ExpenseReport,
    ));
  }
}

/// @nodoc
class _$GeneratedImpl implements _Generated {
  const _$GeneratedImpl({required this.report});

  @override
  final ExpenseReport report;

  @override
  String toString() => 'ReportState.generated(report: $report)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$GeneratedImpl &&
          (identical(other.report, report) || other.report == report));

  @override
  int get hashCode => Object.hash(runtimeType, report);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratedImplCopyWith<_$GeneratedImpl> get copyWith =>
      __$$GeneratedImplCopyWithImpl<_$GeneratedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      generated(report);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      generated?.call(report);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (generated != null) return generated(report);
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      generated(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      generated?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (generated != null) return generated(this);
    return orElse();
  }
}

abstract class _Generated implements ReportState {
  const factory _Generated({required final ExpenseReport report}) =
      _$GeneratedImpl;

  ExpenseReport get report;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratedImplCopyWith<_$GeneratedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// ── _Exporting ────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$ExportingImplCopyWith<$Res> {
  factory _$$ExportingImplCopyWith(
          _$ExportingImpl value, $Res Function(_$ExportingImpl) then) =
      __$$ExportingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExportingImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$ExportingImpl>
    implements _$$ExportingImplCopyWith<$Res> {
  __$$ExportingImplCopyWithImpl(
      _$ExportingImpl _value, $Res Function(_$ExportingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
class _$ExportingImpl implements _Exporting {
  const _$ExportingImpl();

  @override
  String toString() => 'ReportState.exporting()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$ExportingImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      exporting();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      exporting?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exporting != null) return exporting();
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      exporting(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      exporting?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (exporting != null) return exporting(this);
    return orElse();
  }
}

abstract class _Exporting implements ReportState {
  const factory _Exporting() = _$ExportingImpl;
}

// ── _Exported ─────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$ExportedImplCopyWith<$Res> {
  factory _$$ExportedImplCopyWith(
          _$ExportedImpl value, $Res Function(_$ExportedImpl) then) =
      __$$ExportedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filePath});
}

/// @nodoc
class __$$ExportedImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$ExportedImpl>
    implements _$$ExportedImplCopyWith<$Res> {
  __$$ExportedImplCopyWithImpl(
      _$ExportedImpl _value, $Res Function(_$ExportedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filePath = null}) {
    return _then(_$ExportedImpl(
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$ExportedImpl implements _Exported {
  const _$ExportedImpl({required this.filePath});

  @override
  final String filePath;

  @override
  String toString() => 'ReportState.exported(filePath: $filePath)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$ExportedImpl &&
          (identical(other.filePath, filePath) || other.filePath == filePath));

  @override
  int get hashCode => Object.hash(runtimeType, filePath);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportedImplCopyWith<_$ExportedImpl> get copyWith =>
      __$$ExportedImplCopyWithImpl<_$ExportedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      exported(filePath);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      exported?.call(filePath);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exported != null) return exported(filePath);
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      exported(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      exported?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (exported != null) return exported(this);
    return orElse();
  }
}

abstract class _Exported implements ReportState {
  const factory _Exported({required final String filePath}) = _$ExportedImpl;

  String get filePath;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportedImplCopyWith<_$ExportedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// ── _SavedReports ─────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$SavedReportsImplCopyWith<$Res> {
  factory _$$SavedReportsImplCopyWith(
          _$SavedReportsImpl value, $Res Function(_$SavedReportsImpl) then) =
      __$$SavedReportsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ExpenseReport> reports});
}

/// @nodoc
class __$$SavedReportsImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$SavedReportsImpl>
    implements _$$SavedReportsImplCopyWith<$Res> {
  __$$SavedReportsImplCopyWithImpl(
      _$SavedReportsImpl _value, $Res Function(_$SavedReportsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reports = null}) {
    return _then(_$SavedReportsImpl(
      reports: null == reports
          ? _value._reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<ExpenseReport>,
    ));
  }
}

/// @nodoc
class _$SavedReportsImpl implements _SavedReports {
  const _$SavedReportsImpl({required final List<ExpenseReport> reports})
      : _reports = reports;

  final List<ExpenseReport> _reports;

  @override
  List<ExpenseReport> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    return EqualUnmodifiableListView(_reports);
  }

  @override
  String toString() => 'ReportState.savedReports(reports: $reports)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$SavedReportsImpl &&
          const DeepCollectionEquality().equals(other._reports, _reports));

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_reports));

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedReportsImplCopyWith<_$SavedReportsImpl> get copyWith =>
      __$$SavedReportsImplCopyWithImpl<_$SavedReportsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      savedReports(reports);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      savedReports?.call(reports);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (savedReports != null) return savedReports(reports);
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      savedReports(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      savedReports?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (savedReports != null) return savedReports(this);
    return orElse();
  }
}

abstract class _SavedReports implements ReportState {
  const factory _SavedReports(
      {required final List<ExpenseReport> reports}) = _$SavedReportsImpl;

  List<ExpenseReport> get reports;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedReportsImplCopyWith<_$SavedReportsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// ── _Saving ───────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$SavingImplCopyWith<$Res> {
  factory _$$SavingImplCopyWith(
          _$SavingImpl value, $Res Function(_$SavingImpl) then) =
      __$$SavingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SavingImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$SavingImpl>
    implements _$$SavingImplCopyWith<$Res> {
  __$$SavingImplCopyWithImpl(
      _$SavingImpl _value, $Res Function(_$SavingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
class _$SavingImpl implements _Saving {
  const _$SavingImpl();

  @override
  String toString() => 'ReportState.saving()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$SavingImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      saving();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      saving?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saving != null) return saving();
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      saving(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      saving?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (saving != null) return saving(this);
    return orElse();
  }
}

abstract class _Saving implements ReportState {
  const factory _Saving() = _$SavingImpl;
}

// ── _Error ────────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ReportStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() => 'ReportState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$ErrorImpl &&
          (identical(other.message, message) || other.message == message));

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ExpenseReport report) generated,
    required TResult Function() exporting,
    required TResult Function(String filePath) exported,
    required TResult Function(List<ExpenseReport> reports) savedReports,
    required TResult Function() saving,
    required TResult Function(String message) error,
  }) =>
      error(message);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ExpenseReport report)? generated,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exported,
    TResult? Function(List<ExpenseReport> reports)? savedReports,
    TResult? Function()? saving,
    TResult? Function(String message)? error,
  }) =>
      error?.call(message);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ExpenseReport report)? generated,
    TResult Function()? exporting,
    TResult Function(String filePath)? exported,
    TResult Function(List<ExpenseReport> reports)? savedReports,
    TResult Function()? saving,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) return error(message);
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Generated value) generated,
    required TResult Function(_Exporting value) exporting,
    required TResult Function(_Exported value) exported,
    required TResult Function(_SavedReports value) savedReports,
    required TResult Function(_Saving value) saving,
    required TResult Function(_Error value) error,
  }) =>
      error(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Generated value)? generated,
    TResult? Function(_Exporting value)? exporting,
    TResult? Function(_Exported value)? exported,
    TResult? Function(_SavedReports value)? savedReports,
    TResult? Function(_Saving value)? saving,
    TResult? Function(_Error value)? error,
  }) =>
      error?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Generated value)? generated,
    TResult Function(_Exporting value)? exporting,
    TResult Function(_Exported value)? exported,
    TResult Function(_SavedReports value)? savedReports,
    TResult Function(_Saving value)? saving,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) return error(this);
    return orElse();
  }
}

abstract class _Error implements ReportState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
