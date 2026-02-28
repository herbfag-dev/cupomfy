import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_rule.freezed.dart';
part 'recurring_rule.g.dart';

/// How often a recurring transaction repeats.
enum RecurrenceFrequency { daily, weekly, biweekly, monthly, yearly }

/// A rule that drives automatic generation of recurring expense entries.
///
/// Each rule stores the template for an expense (amount, category, title)
/// and the schedule (frequency, start date, optional end date).
/// The data layer is responsible for generating the next occurrence date
/// and creating the actual expense records.
@freezed
class RecurringRule with _$RecurringRule {
  const factory RecurringRule({
    required String id,
    required String userId,

    /// Optional category for the generated expenses.
    String? categoryId,

    /// Human-readable label, e.g. "Netflix subscription".
    required String title,

    /// Amount of each generated expense.
    required double amount,

    /// ISO 4217 currency code.
    @Default('USD') String currency,

    /// Optional notes copied to each generated expense.
    String? notes,

    /// How often the rule fires.
    @Default(RecurrenceFrequency.monthly) RecurrenceFrequency frequency,

    /// When the rule first fires.
    required DateTime startDate,

    /// Optional: rule stops generating after this date.
    DateTime? endDate,

    /// Date of the most recently generated expense (null if never run).
    DateTime? lastGeneratedAt,

    /// Date the next expense will be generated.
    required DateTime nextDueDate,

    /// Whether the rule is currently active.
    @Default(true) bool isActive,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RecurringRule;

  factory RecurringRule.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleFromJson(json);
}

extension RecurringRuleX on RecurringRule {
  /// Returns true if the rule is due today or overdue.
  bool get isDue => nextDueDate.isBefore(
        DateTime.now().add(const Duration(days: 1)),
      );

  /// Human-readable frequency label.
  String get frequencyLabel {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Every 2 weeks';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }

  /// Computes the next due date after [from] based on [frequency].
  DateTime nextDueDateAfter(DateTime from) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return from.add(const Duration(days: 1));
      case RecurrenceFrequency.weekly:
        return from.add(const Duration(days: 7));
      case RecurrenceFrequency.biweekly:
        return from.add(const Duration(days: 14));
      case RecurrenceFrequency.monthly:
        return DateTime(from.year, from.month + 1, from.day);
      case RecurrenceFrequency.yearly:
        return DateTime(from.year + 1, from.month, from.day);
    }
  }
}
