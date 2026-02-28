import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../expenses/domain/entities/category.dart';
import '../../../expenses/domain/entities/expense.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = DashboardInitial;

  const factory DashboardState.loading() = DashboardLoading;

  const factory DashboardState.loaded({
    required double monthlyTotal,
    required int transactionCount,
    required Category? topCategory,
    required double topCategoryAmount,
    required List<Expense> recentExpenses,
    required DateTime lastUpdated,
  }) = DashboardLoaded;

  const factory DashboardState.error({
    required String message,
  }) = DashboardError;
}
