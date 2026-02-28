import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  // ─── Public API ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Budget>>> getBudgets({
    required String userId,
  }) async {
    try {
      final rows = await _supabaseClient
          .from('budgets')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at');

      final budgets = await Future.wait(
        (rows as List<dynamic>)
            .map((r) => _rowToBudgetWithSpent(r as Map<String, dynamic>)),
      );

      return Right(budgets);
    } catch (e, st) {
      AppLogger.error('getBudgets failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final rows = await _supabaseClient
          .from('budgets')
          .select()
          .eq('id', id)
          .limit(1);

      final list = rows as List<dynamic>;
      if (list.isEmpty) {
        return const Left(Failure.notFound(message: 'Budget not found'));
      }

      final budget =
          await _rowToBudgetWithSpent(list.first as Map<String, dynamic>);
      return Right(budget);
    } catch (e, st) {
      AppLogger.error('getBudgetById failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget(Budget budget) async {
    try {
      final now = DateTime.now();
      final newBudget = budget.copyWith(
        id: budget.id.isEmpty ? _uuid.v4() : budget.id,
        createdAt: now,
        updatedAt: now,
      );

      await _supabaseClient.from('budgets').insert(_budgetToRow(newBudget));

      return Right(newBudget);
    } catch (e, st) {
      AppLogger.error('createBudget failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget(Budget budget) async {
    try {
      final updated = budget.copyWith(updatedAt: DateTime.now());
      await _supabaseClient
          .from('budgets')
          .update(_budgetToRow(updated))
          .eq('id', updated.id);

      return Right(updated);
    } catch (e, st) {
      AppLogger.error('updateBudget failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(String id) async {
    try {
      await _supabaseClient
          .from('budgets')
          .update({'is_active': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('deleteBudget failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Budget>>> watchBudgets({
    required String userId,
  }) {
    return _supabaseClient
        .from('budgets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .asyncMap((rows) async {
          final active = rows
              .where((r) => r['is_active'] == true)
              .toList();
          final budgets = await Future.wait(
            active.map((r) => _rowToBudgetWithSpent(r)),
          );
          return Right<Failure, List<Budget>>(budgets);
        })
        .handleError(
          (Object e) => Left<Failure, List<Budget>>(
            Failure.server(message: e.toString()),
          ),
        );
  }

  // ─── Private Helpers ───────────────────────────────────────────────────────

  /// Converts a Supabase row to a [Budget] and populates [spent] by
  /// summing expenses that fall within the budget window.
  Future<Budget> _rowToBudgetWithSpent(Map<String, dynamic> row) async {
    final budget = _rowToBudget(row);

    try {
      var query = _supabaseClient
          .from('expenses')
          .select('amount')
          .eq('user_id', budget.userId)
          .gte('date', budget.startDate.toIso8601String())
          .lt('date', budget.endDate.toIso8601String());

      if (budget.categoryId != null) {
        query = query.eq('category_id', budget.categoryId!);
      }

      final expenseRows = await query;
      final spent = (expenseRows as List<dynamic>).fold<double>(
        0.0,
        (sum, r) => sum + ((r as Map<String, dynamic>)['amount'] as num).toDouble(),
      );

      return budget.copyWith(spent: spent);
    } catch (_) {
      // If we can't compute spent, return the budget with 0 spent
      return budget;
    }
  }

  Budget _rowToBudget(Map<String, dynamic> row) {
    return Budget(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      categoryId: row['category_id'] as String?,
      name: row['name'] as String,
      amount: (row['amount'] as num).toDouble(),
      currency: row['currency'] as String? ?? 'USD',
      period: _parsePeriod(row['period'] as String?),
      startDate: DateTime.parse(row['start_date'] as String),
      endDate: DateTime.parse(row['end_date'] as String),
      isActive: row['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, dynamic> _budgetToRow(Budget budget) {
    return {
      'id': budget.id,
      'user_id': budget.userId,
      'category_id': budget.categoryId,
      'name': budget.name,
      'amount': budget.amount,
      'currency': budget.currency,
      'period': budget.period.name,
      'start_date': budget.startDate.toIso8601String(),
      'end_date': budget.endDate.toIso8601String(),
      'is_active': budget.isActive,
      'created_at': budget.createdAt.toIso8601String(),
      'updated_at': budget.updatedAt.toIso8601String(),
    };
  }

  BudgetPeriod _parsePeriod(String? value) {
    switch (value) {
      case 'weekly':
        return BudgetPeriod.weekly;
      case 'yearly':
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.monthly;
    }
  }
}
