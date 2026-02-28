import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';

part 'expense_state.freezed.dart';

@freezed
class ExpenseState with _$ExpenseState {
  const factory ExpenseState.initial() = ExpenseInitial;

  const factory ExpenseState.loading() = ExpenseLoading;

  const factory ExpenseState.expensesLoaded({
    required List<Expense> expenses,
    required List<Category> categories,
    String? searchQuery,
    String? selectedCategoryId,
    DateTime? startDate,
    DateTime? endDate,
    ExpenseSortBy sortBy,
  }) = ExpensesLoaded;

  const factory ExpenseState.expenseLoaded({
    required Expense expense,
    required List<Category> categories,
  }) = ExpenseLoaded;

  const factory ExpenseState.expenseCreated({
    required Expense expense,
  }) = ExpenseCreated;

  const factory ExpenseState.expenseUpdated({
    required Expense expense,
  }) = ExpenseUpdated;

  const factory ExpenseState.expenseDeleted() = ExpenseDeleted;

  const factory ExpenseState.error({
    required String message,
  }) = ExpenseError;
}
