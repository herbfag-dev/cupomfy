import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../expenses/domain/entities/expense.dart';

part 'expense_report.freezed.dart';
part 'expense_report.g.dart';

/// Breakdown of spending for a single category within a report period.
@freezed
class CategoryBreakdown with _$CategoryBreakdown {
  const factory CategoryBreakdown({
    required String categoryId,
    required String categoryName,

    /// Total amount spent in this category.
    required double amount,

    /// Percentage of total spending (0–100).
    required double percentage,

    /// Number of expenses in this category.
    required int count,
  }) = _CategoryBreakdown;

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownFromJson(json);
}

/// Total spending for a single calendar day.
@freezed
class DailyTotal with _$DailyTotal {
  const factory DailyTotal({
    required DateTime date,
    required double amount,
  }) = _DailyTotal;

  factory DailyTotal.fromJson(Map<String, dynamic> json) =>
      _$DailyTotalFromJson(json);
}

/// A generated expense report summarising spending over a date range.
///
/// Contains aggregated statistics (totals, category breakdown, daily totals)
/// and the top 5 expenses by amount for the period.
@freezed
class ExpenseReport with _$ExpenseReport {
  const factory ExpenseReport({
    required String id,
    required String userId,

    /// Human-readable title, e.g. "January 2025 Report".
    required String title,

    /// Inclusive start of the reporting period.
    required DateTime startDate,

    /// Inclusive end of the reporting period.
    required DateTime endDate,

    /// Sum of all expense amounts in the period.
    required double totalAmount,

    /// ISO 4217 currency code.
    @Default('USD') String currency,

    /// Per-category spending breakdown, sorted by amount descending.
    @Default([]) List<CategoryBreakdown> categoryBreakdown,

    /// Daily spending totals, sorted by date ascending.
    @Default([]) List<DailyTotal> dailyTotals,

    /// Top 5 expenses by amount, sorted descending.
    @Default([]) List<Expense> topExpenses,

    /// When this report was generated.
    required DateTime generatedAt,
  }) = _ExpenseReport;

  factory ExpenseReport.fromJson(Map<String, dynamic> json) =>
      _$ExpenseReportFromJson(json);
}

extension ExpenseReportX on ExpenseReport {
  /// Total number of expenses in the report period.
  int get transactionCount => dailyTotals.fold(0, (sum, d) {
        // Count from category breakdown (more accurate)
        return sum;
      });

  /// Number of days in the reporting period.
  int get periodDays => endDate.difference(startDate).inDays + 1;

  /// Average daily spending.
  double get averageDailySpend =>
      periodDays > 0 ? totalAmount / periodDays : 0.0;

  /// Total number of transactions (sum of category counts).
  int get totalTransactionCount =>
      categoryBreakdown.fold(0, (sum, c) => sum + c.count);
}
