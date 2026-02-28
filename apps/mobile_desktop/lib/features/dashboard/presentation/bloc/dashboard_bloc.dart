import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../expenses/domain/entities/category.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._expenseRepository) : super(const DashboardState.initial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  final ExpenseRepository _expenseRepository;

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _loadDashboardData(
    String userId,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());

    try {
      // Get current month's date range
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      // Fetch expenses for current month
      final filter = ExpenseFilter(
        userId: userId,
        startDate: startOfMonth,
        endDate: endOfMonth,
        sortBy: ExpenseSortBy.dateDesc,
      );

      final result = await _expenseRepository.getExpenses(filter);

      await result.fold(
        (failure) async {
          AppLogger.error('Failed to load dashboard data', failure);
          emit(DashboardState.error(message: _mapFailureToMessage(failure)));
        },
        (expenses) async {
          // Calculate monthly total
          final monthlyTotal = expenses.fold<double>(
            0,
            (sum, expense) => sum + expense.amount,
          );

          // Get transaction count
          final transactionCount = expenses.length;

          // Get recent expenses (last 10)
          final recentExpenses = expenses.take(10).toList();

          // Calculate top category
          final categoryTotals = <String, double>{};
          final categoryMap = <String, Category>{};

          for (final expense in expenses) {
            final categoryId = expense.categoryId;
            if (categoryId != null && categoryId.isNotEmpty) {
              categoryTotals[categoryId] =
                  (categoryTotals[categoryId] ?? 0) + expense.amount;
            }
          }

          // Get categories to map IDs to names
          final categoriesResult = await _expenseRepository.getCategories(
            userId: userId,
          );

          Category? topCategory;
          double topCategoryAmount = 0;

          categoriesResult.fold(
            (failure) {
              // If we can't load categories, we'll still show the dashboard
              // but without category names
              AppLogger.warning('Failed to load categories: $failure');
            },
            (categories) {
              for (final category in categories) {
                categoryMap[category.id] = category;
              }

              // Find top category
              String? topCategoryId;
              for (final entry in categoryTotals.entries) {
                if (entry.value > topCategoryAmount) {
                  topCategoryAmount = entry.value;
                  topCategoryId = entry.key;
                }
              }

              if (topCategoryId != null) {
                topCategory = categoryMap[topCategoryId];
              }
            },
          );

          emit(DashboardState.loaded(
            monthlyTotal: monthlyTotal,
            transactionCount: transactionCount,
            topCategory: topCategory,
            topCategoryAmount: topCategoryAmount,
            recentExpenses: recentExpenses,
            lastUpdated: DateTime.now(),
          ));
        },
      );
    } catch (e, st) {
      AppLogger.error('Unexpected error loading dashboard', e, st);
      emit(DashboardState.error(message: 'An unexpected error occurred'));
    }
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
