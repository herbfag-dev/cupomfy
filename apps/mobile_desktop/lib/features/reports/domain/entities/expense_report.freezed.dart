// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryBreakdown _$CategoryBreakdownFromJson(Map<String, dynamic> json) {
  return _CategoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$CategoryBreakdown {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

  /// Total amount spent in this category.
  double get amount => throw _privateConstructorUsedError;

  /// Percentage of total spending (0–100).
  double get percentage => throw _privateConstructorUsedError;

  /// Number of expenses in this category.
  int get count => throw _privateConstructorUsedError;

  /// Serializes this CategoryBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBreakdownCopyWith<$Res> {
  factory $CategoryBreakdownCopyWith(
          CategoryBreakdown value, $Res Function(CategoryBreakdown) then) =
      _$CategoryBreakdownCopyWithImpl<$Res, CategoryBreakdown>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      double amount,
      double percentage,
      int count});
}

/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res, $Val extends CategoryBreakdown>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? amount = null,
    Object? percentage = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryBreakdownImplCopyWith<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  factory _$$CategoryBreakdownImplCopyWith(_$CategoryBreakdownImpl value,
          $Res Function(_$CategoryBreakdownImpl) then) =
      __$$CategoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      double amount,
      double percentage,
      int count});
}

/// @nodoc
class __$$CategoryBreakdownImplCopyWithImpl<$Res>
    extends _$CategoryBreakdownCopyWithImpl<$Res, _$CategoryBreakdownImpl>
    implements _$$CategoryBreakdownImplCopyWith<$Res> {
  __$$CategoryBreakdownImplCopyWithImpl(_$CategoryBreakdownImpl _value,
      $Res Function(_$CategoryBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? amount = null,
    Object? percentage = null,
    Object? count = null,
  }) {
    return _then(_$CategoryBreakdownImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBreakdownImpl implements _CategoryBreakdown {
  const _$CategoryBreakdownImpl(
      {required this.categoryId,
      required this.categoryName,
      required this.amount,
      required this.percentage,
      required this.count});

  factory _$CategoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBreakdownImplFromJson(json);

  @override
  final String categoryId;
  @override
  final String categoryName;

  /// Total amount spent in this category.
  @override
  final double amount;

  /// Percentage of total spending (0–100).
  @override
  final double percentage;

  /// Number of expenses in this category.
  @override
  final int count;

  @override
  String toString() {
    return 'CategoryBreakdown(categoryId: $categoryId, categoryName: $categoryName, amount: $amount, percentage: $percentage, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBreakdownImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, categoryId, categoryName, amount, percentage, count);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      __$$CategoryBreakdownImplCopyWithImpl<_$CategoryBreakdownImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBreakdownImplToJson(
      this,
    );
  }
}

abstract class _CategoryBreakdown implements CategoryBreakdown {
  const factory _CategoryBreakdown(
      {required final String categoryId,
      required final String categoryName,
      required final double amount,
      required final double percentage,
      required final int count}) = _$CategoryBreakdownImpl;

  factory _CategoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$CategoryBreakdownImpl.fromJson;

  @override
  String get categoryId;
  @override
  String get categoryName;

  /// Total amount spent in this category.
  @override
  double get amount;

  /// Percentage of total spending (0–100).
  @override
  double get percentage;

  /// Number of expenses in this category.
  @override
  int get count;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyTotal _$DailyTotalFromJson(Map<String, dynamic> json) {
  return _DailyTotal.fromJson(json);
}

/// @nodoc
mixin _$DailyTotal {
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this DailyTotal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyTotal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyTotalCopyWith<DailyTotal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyTotalCopyWith<$Res> {
  factory $DailyTotalCopyWith(
          DailyTotal value, $Res Function(DailyTotal) then) =
      _$DailyTotalCopyWithImpl<$Res, DailyTotal>;
  @useResult
  $Res call({DateTime date, double amount});
}

/// @nodoc
class _$DailyTotalCopyWithImpl<$Res, $Val extends DailyTotal>
    implements $DailyTotalCopyWith<$Res> {
  _$DailyTotalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyTotal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyTotalImplCopyWith<$Res>
    implements $DailyTotalCopyWith<$Res> {
  factory _$$DailyTotalImplCopyWith(
          _$DailyTotalImpl value, $Res Function(_$DailyTotalImpl) then) =
      __$$DailyTotalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double amount});
}

/// @nodoc
class __$$DailyTotalImplCopyWithImpl<$Res>
    extends _$DailyTotalCopyWithImpl<$Res, _$DailyTotalImpl>
    implements _$$DailyTotalImplCopyWith<$Res> {
  __$$DailyTotalImplCopyWithImpl(
      _$DailyTotalImpl _value, $Res Function(_$DailyTotalImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyTotal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
  }) {
    return _then(_$DailyTotalImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyTotalImpl implements _DailyTotal {
  const _$DailyTotalImpl({required this.date, required this.amount});

  factory _$DailyTotalImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyTotalImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double amount;

  @override
  String toString() {
    return 'DailyTotal(date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyTotalImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, amount);

  /// Create a copy of DailyTotal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyTotalImplCopyWith<_$DailyTotalImpl> get copyWith =>
      __$$DailyTotalImplCopyWithImpl<_$DailyTotalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyTotalImplToJson(
      this,
    );
  }
}

abstract class _DailyTotal implements DailyTotal {
  const factory _DailyTotal(
      {required final DateTime date,
      required final double amount}) = _$DailyTotalImpl;

  factory _DailyTotal.fromJson(Map<String, dynamic> json) =
      _$DailyTotalImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get amount;

  /// Create a copy of DailyTotal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyTotalImplCopyWith<_$DailyTotalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpenseReport _$ExpenseReportFromJson(Map<String, dynamic> json) {
  return _ExpenseReport.fromJson(json);
}

/// @nodoc
mixin _$ExpenseReport {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  /// Human-readable title, e.g. "January 2025 Report".
  String get title => throw _privateConstructorUsedError;

  /// Inclusive start of the reporting period.
  DateTime get startDate => throw _privateConstructorUsedError;

  /// Inclusive end of the reporting period.
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Sum of all expense amounts in the period.
  double get totalAmount => throw _privateConstructorUsedError;

  /// ISO 4217 currency code.
  String get currency => throw _privateConstructorUsedError;

  /// Per-category spending breakdown, sorted by amount descending.
  List<CategoryBreakdown> get categoryBreakdown =>
      throw _privateConstructorUsedError;

  /// Daily spending totals, sorted by date ascending.
  List<DailyTotal> get dailyTotals => throw _privateConstructorUsedError;

  /// Top 5 expenses by amount, sorted descending.
  List<Expense> get topExpenses => throw _privateConstructorUsedError;

  /// When this report was generated.
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseReportCopyWith<ExpenseReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseReportCopyWith<$Res> {
  factory $ExpenseReportCopyWith(
          ExpenseReport value, $Res Function(ExpenseReport) then) =
      _$ExpenseReportCopyWithImpl<$Res, ExpenseReport>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      DateTime startDate,
      DateTime endDate,
      double totalAmount,
      String currency,
      List<CategoryBreakdown> categoryBreakdown,
      List<DailyTotal> dailyTotals,
      List<Expense> topExpenses,
      DateTime generatedAt});
}

/// @nodoc
class _$ExpenseReportCopyWithImpl<$Res, $Val extends ExpenseReport>
    implements $ExpenseReportCopyWith<$Res> {
  _$ExpenseReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? categoryBreakdown = null,
    Object? dailyTotals = null,
    Object? topExpenses = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryBreakdown: null == categoryBreakdown
          ? _value.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
      dailyTotals: null == dailyTotals
          ? _value.dailyTotals
          : dailyTotals // ignore: cast_nullable_to_non_nullable
              as List<DailyTotal>,
      topExpenses: null == topExpenses
          ? _value.topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseReportImplCopyWith<$Res>
    implements $ExpenseReportCopyWith<$Res> {
  factory _$$ExpenseReportImplCopyWith(
          _$ExpenseReportImpl value, $Res Function(_$ExpenseReportImpl) then) =
      __$$ExpenseReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      DateTime startDate,
      DateTime endDate,
      double totalAmount,
      String currency,
      List<CategoryBreakdown> categoryBreakdown,
      List<DailyTotal> dailyTotals,
      List<Expense> topExpenses,
      DateTime generatedAt});
}

/// @nodoc
class __$$ExpenseReportImplCopyWithImpl<$Res>
    extends _$ExpenseReportCopyWithImpl<$Res, _$ExpenseReportImpl>
    implements _$$ExpenseReportImplCopyWith<$Res> {
  __$$ExpenseReportImplCopyWithImpl(
      _$ExpenseReportImpl _value, $Res Function(_$ExpenseReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? categoryBreakdown = null,
    Object? dailyTotals = null,
    Object? topExpenses = null,
    Object? generatedAt = null,
  }) {
    return _then(_$ExpenseReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryBreakdown: null == categoryBreakdown
          ? _value._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
      dailyTotals: null == dailyTotals
          ? _value._dailyTotals
          : dailyTotals // ignore: cast_nullable_to_non_nullable
              as List<DailyTotal>,
      topExpenses: null == topExpenses
          ? _value._topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseReportImpl implements _ExpenseReport {
  const _$ExpenseReportImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.totalAmount,
      this.currency = 'USD',
      final List<CategoryBreakdown> categoryBreakdown = const [],
      final List<DailyTotal> dailyTotals = const [],
      final List<Expense> topExpenses = const [],
      required this.generatedAt})
      : _categoryBreakdown = categoryBreakdown,
        _dailyTotals = dailyTotals,
        _topExpenses = topExpenses;

  factory _$ExpenseReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseReportImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;

  /// Human-readable title, e.g. "January 2025 Report".
  @override
  final String title;

  /// Inclusive start of the reporting period.
  @override
  final DateTime startDate;

  /// Inclusive end of the reporting period.
  @override
  final DateTime endDate;

  /// Sum of all expense amounts in the period.
  @override
  final double totalAmount;

  /// ISO 4217 currency code.
  @override
  @JsonKey()
  final String currency;

  /// Per-category spending breakdown, sorted by amount descending.
  final List<CategoryBreakdown> _categoryBreakdown;

  /// Per-category spending breakdown, sorted by amount descending.
  @override
  @JsonKey()
  List<CategoryBreakdown> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  /// Daily spending totals, sorted by date ascending.
  final List<DailyTotal> _dailyTotals;

  /// Daily spending totals, sorted by date ascending.
  @override
  @JsonKey()
  List<DailyTotal> get dailyTotals {
    if (_dailyTotals is EqualUnmodifiableListView) return _dailyTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyTotals);
  }

  /// Top 5 expenses by amount, sorted descending.
  final List<Expense> _topExpenses;

  /// Top 5 expenses by amount, sorted descending.
  @override
  @JsonKey()
  List<Expense> get topExpenses {
    if (_topExpenses is EqualUnmodifiableListView) return _topExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topExpenses);
  }

  /// When this report was generated.
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'ExpenseReport(id: $id, userId: $userId, title: $title, startDate: $startDate, endDate: $endDate, totalAmount: $totalAmount, currency: $currency, categoryBreakdown: $categoryBreakdown, dailyTotals: $dailyTotals, topExpenses: $topExpenses, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._dailyTotals, _dailyTotals) &&
            const DeepCollectionEquality()
                .equals(other._topExpenses, _topExpenses) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      startDate,
      endDate,
      totalAmount,
      currency,
      const DeepCollectionEquality().hash(_categoryBreakdown),
      const DeepCollectionEquality().hash(_dailyTotals),
      const DeepCollectionEquality().hash(_topExpenses),
      generatedAt);

  /// Create a copy of ExpenseReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseReportImplCopyWith<_$ExpenseReportImpl> get copyWith =>
      __$$ExpenseReportImplCopyWithImpl<_$ExpenseReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseReportImplToJson(
      this,
    );
  }
}

abstract class _ExpenseReport implements ExpenseReport {
  const factory _ExpenseReport(
      {required final String id,
      required final String userId,
      required final String title,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double totalAmount,
      final String currency,
      final List<CategoryBreakdown> categoryBreakdown,
      final List<DailyTotal> dailyTotals,
      final List<Expense> topExpenses,
      required final DateTime generatedAt}) = _$ExpenseReportImpl;

  factory _ExpenseReport.fromJson(Map<String, dynamic> json) =
      _$ExpenseReportImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;

  /// Human-readable title, e.g. "January 2025 Report".
  @override
  String get title;

  /// Inclusive start of the reporting period.
  @override
  DateTime get startDate;

  /// Inclusive end of the reporting period.
  @override
  DateTime get endDate;

  /// Sum of all expense amounts in the period.
  @override
  double get totalAmount;

  /// ISO 4217 currency code.
  @override
  String get currency;

  /// Per-category spending breakdown, sorted by amount descending.
  @override
  List<CategoryBreakdown> get categoryBreakdown;

  /// Daily spending totals, sorted by date ascending.
  @override
  List<DailyTotal> get dailyTotals;

  /// Top 5 expenses by amount, sorted descending.
  @override
  List<Expense> get topExpenses;

  /// When this report was generated.
  @override
  DateTime get generatedAt;

  /// Create a copy of ExpenseReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseReportImplCopyWith<_$ExpenseReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
