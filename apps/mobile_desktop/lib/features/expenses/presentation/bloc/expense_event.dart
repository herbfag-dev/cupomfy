import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/expense.dart';

part 'expense_event.freezed.dart';

@freezed
class ExpenseEvent with _$ExpenseEvent {
  const factory ExpenseEvent.loadExpenses({
    required String userId,
    String? searchQuery,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    ExpenseSortBy? sortBy,
  }) = LoadExpenses;

  const factory ExpenseEvent.refreshExpenses() = RefreshExpenses;

  const factory ExpenseEvent.loadExpense({
    required String expenseId,
  }) = LoadExpense;

  const factory ExpenseEvent.createExpense({
    required Expense expense,
  }) = CreateExpense;

  const factory ExpenseEvent.updateExpense({
    required Expense expense,
  }) = UpdateExpense;

  const factory ExpenseEvent.deleteExpense({
    required String expenseId,
  }) = DeleteExpense;

  const factory ExpenseEvent.searchExpenses({
    required String query,
  }) = SearchExpenses;

  const factory ExpenseEvent.filterByCategory({
    required String? categoryId,
  }) = FilterByCategory;

  const factory ExpenseEvent.filterByDateRange({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = FilterByDateRange;

  const factory ExpenseEvent.sortExpenses({
    required ExpenseSortBy sortBy,
  }) = SortExpenses;
}
