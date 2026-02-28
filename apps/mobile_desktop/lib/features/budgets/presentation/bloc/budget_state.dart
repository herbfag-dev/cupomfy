part of 'budget_bloc.dart';

@freezed
class BudgetState with _$BudgetState {
  /// No data loaded yet.
  const factory BudgetState.initial() = _Initial;

  /// Fetching budgets from the server.
  const factory BudgetState.loading() = _Loading;

  /// Budgets loaded successfully.
  const factory BudgetState.loaded(List<Budget> budgets) = _Loaded;

  /// A create/update operation is in progress.
  const factory BudgetState.saving() = _Saving;

  /// An error occurred.
  const factory BudgetState.error(String message) = _Error;
}
