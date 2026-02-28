part of 'budget_bloc.dart';

@freezed
class BudgetEvent with _$BudgetEvent {
  /// Load (and watch) all budgets for [userId].
  const factory BudgetEvent.load({required String userId}) = _Load;

  /// Create a new budget.
  const factory BudgetEvent.create({required Budget budget}) = _Create;

  /// Update an existing budget.
  const factory BudgetEvent.update({required Budget budget}) = _Update;

  /// Delete (deactivate) a budget by [budgetId].
  const factory BudgetEvent.delete({required String budgetId}) = _Delete;

  /// Internal: emitted by the real-time stream subscription.
  const factory BudgetEvent.budgetsUpdated({
    required List<Budget> budgets,
    String? errorMessage,
  }) = _BudgetsUpdated;
}
