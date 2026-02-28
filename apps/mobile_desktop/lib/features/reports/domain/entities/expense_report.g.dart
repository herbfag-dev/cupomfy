// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryBreakdownImpl _$$CategoryBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryBreakdownImpl(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$CategoryBreakdownImplToJson(
        _$CategoryBreakdownImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'count': instance.count,
    };

_$DailyTotalImpl _$$DailyTotalImplFromJson(Map<String, dynamic> json) =>
    _$DailyTotalImpl(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyTotalImplToJson(_$DailyTotalImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
    };

_$ExpenseReportImpl _$$ExpenseReportImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseReportImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>?)
              ?.map((e) =>
                  CategoryBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyTotals: (json['dailyTotals'] as List<dynamic>?)
              ?.map((e) => DailyTotal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topExpenses: (json['topExpenses'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseReportImplToJson(
        _$ExpenseReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'categoryBreakdown':
          instance.categoryBreakdown.map((e) => e.toJson()).toList(),
      'dailyTotals': instance.dailyTotals.map((e) => e.toJson()).toList(),
      'topExpenses': instance.topExpenses.map((e) => e.toJson()).toList(),
      'generatedAt': instance.generatedAt.toIso8601String(),
    };
