import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

/// Represents the recurrence period for a budget.
enum BudgetPeriod { monthly, weekly, yearly }

/// A budget sets a spending limit for a category over a given period.
@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,

    /// Optional: if null the budget applies to all categories.
    String? categoryId,

    /// Human-readable name, e.g. "Groceries – March".
    required String name,

    /// The spending limit in the user's currency.
    required double amount,

    /// ISO 4217 currency code, e.g. "USD".
    @Default('USD') String currency,

    /// How often the budget resets.
    @Default(BudgetPeriod.monthly) BudgetPeriod period,

    /// Start of the current budget window.
    required DateTime startDate,

    /// End of the current budget window (exclusive).
    required DateTime endDate,

    /// How much has been spent so far in this window (computed, not stored).
    @Default(0.0) double spent,

    /// Whether this budget is currently active.
    @Default(true) bool isActive,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) =>
      _$BudgetFromJson(json);
}

extension BudgetX on Budget {
  /// Remaining amount before the budget is exceeded.
  double get remaining => amount - spent;

  /// Progress as a value between 0.0 and 1.0 (clamped).
  double get progress => (spent / amount).clamp(0.0, 1.0);

  /// True when spending has reached or exceeded the limit.
  bool get isExceeded => spent >= amount;

  /// True when spending is within 10 % of the limit.
  bool get isNearLimit => !isExceeded && progress >= 0.9;
}
