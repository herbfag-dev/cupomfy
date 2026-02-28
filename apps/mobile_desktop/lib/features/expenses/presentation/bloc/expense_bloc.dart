import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

@injectable
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc(this._expenseRepository) : super(const ExpenseState.initial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<RefreshExpenses>(_onRefreshExpenses);
    on<LoadExpense>(_onLoadExpense);
    on<CreateExpense>(_onCreateExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<SearchExpenses>(_onSearchExpenses);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByDateRange>(_onFilterByDateRange);
    on<SortExpenses>(_onSortExpenses);
  }

  final ExpenseRepository _expenseRepository;

  // Current filter state for refresh operations
  String? _currentUserId;
  String? _currentSearchQuery;
  String? _currentCategoryId;
  DateTime? _currentStartDate;
  DateTime? _currentEndDate;
  ExpenseSortBy _currentSortBy = ExpenseSortBy.dateDesc;

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());

    // Store current filter state
    _currentUserId = event.userId;
    _currentSearchQuery = event.searchQuery;
    _currentCategoryId = event.categoryId;
    _currentStartDate = event.startDate;
    _currentEndDate = event.endDate;
    _currentSortBy = event.sortBy ?? ExpenseSortBy.dateDesc;

    await _loadExpenses(emit);
  }

  Future<void> _onRefreshExpenses(
    RefreshExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());
    await _loadExpenses(emit);
  }

  Future<void> _loadExpenses(Emitter<ExpenseState> emit) async {
    if (_currentUserId == null) {
      emit(const ExpenseState.error(message: 'User ID is required'));
      return;
    }

    final filter = ExpenseFilter(
      userId: _currentUserId!,
      searchQuery: _currentSearchQuery,
      categoryId: _currentCategoryId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      sortBy: _currentSortBy,
    );

    final expensesResult = await _expenseRepository.getExpenses(filter);
    final categoriesResult = await _expenseRepository.getCategories(
      userId: _currentUserId,
    );

    await expensesResult.fold(
      (failure) async {
        emit(ExpenseState.error(message: _mapFailureToMessage(failure)));
      },
      (expenses) async {
        final categories = categoriesResult.getOrElse(() => []);
        emit(ExpenseState.expensesLoaded(
          expenses: expenses,
          categories: categories,
          searchQuery: _currentSearchQuery,
          selectedCategoryId: _currentCategoryId,
          startDate: _currentStartDate,
          endDate: _currentEndDate,
          sortBy: _currentSortBy,
        ));
      },
    );
  }

  Future<void> _onLoadExpense(
    LoadExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());

    final expenseResult = await _expenseRepository.getExpenseById(
      event.expenseId,
    );

    await expenseResult.fold(
      (failure) async {
        emit(ExpenseState.error(message: _mapFailureToMessage(failure)));
      },
      (expense) async {
        final categoriesResult = await _expenseRepository.getCategories(
          userId: expense.userId,
        );
        final categories = categoriesResult.getOrElse(() => []);
        emit(ExpenseState.expenseLoaded(
          expense: expense,
          categories: categories,
        ));
      },
    );
  }

  Future<void> _onCreateExpense(
    CreateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());

    final result = await _expenseRepository.createExpense(event.expense);

    result.fold(
      (failure) => emit(ExpenseState.error(message: _mapFailureToMessage(failure))),
      (expense) => emit(ExpenseState.expenseCreated(expense: expense)),
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());

    final result = await _expenseRepository.updateExpense(event.expense);

    result.fold(
      (failure) => emit(ExpenseState.error(message: _mapFailureToMessage(failure))),
      (expense) => emit(ExpenseState.expenseUpdated(expense: expense)),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseState.loading());

    final result = await _expenseRepository.deleteExpense(event.expenseId);

    result.fold(
      (failure) => emit(ExpenseState.error(message: _mapFailureToMessage(failure))),
      (_) => emit(const ExpenseState.expenseDeleted()),
    );
  }

  Future<void> _onSearchExpenses(
    SearchExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    _currentSearchQuery = event.query.isEmpty ? null : event.query;
    emit(const ExpenseState.loading());
    await _loadExpenses(emit);
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExpenseState> emit,
  ) async {
    _currentCategoryId = event.categoryId;
    emit(const ExpenseState.loading());
    await _loadExpenses(emit);
  }

  Future<void> _onFilterByDateRange(
    FilterByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    _currentStartDate = event.startDate;
    _currentEndDate = event.endDate;
    emit(const ExpenseState.loading());
    await _loadExpenses(emit);
  }

  Future<void> _onSortExpenses(
    SortExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    _currentSortBy = event.sortBy;
    emit(const ExpenseState.loading());
    await _loadExpenses(emit);
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      server: (message) => message ?? 'Server error occurred',
      cache: (message) => message ?? 'Cache error occurred',
      network: () => 'Network error. Please check your connection',
      notFound: (message) => message ?? 'Resource not found',
      unauthorized: () => 'Unauthorized access',
      forbidden: () => 'Access forbidden',
      validation: (message) => message ?? 'Validation error',
      unknown: (message) => message ?? 'An unexpected error occurred',
    );
  }
}
