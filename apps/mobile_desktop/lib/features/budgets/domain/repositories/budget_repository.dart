import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/budget.dart';

/// Contract for all budget-related data operations.
///
/// Follows the Repository pattern (Clean Architecture / DIP):
/// the domain layer depends on this abstraction; the data layer
/// provides the concrete implementation.
abstract class BudgetRepository {
  /// Returns all active budgets for [userId], with [spent] populated.
  Future<Either<Failure, List<Budget>>> getBudgets({
    required String userId,
  });

  /// Returns a single budget by [id], with [spent] populated.
  Future<Either<Failure, Budget>> getBudgetById(String id);

  /// Persists a new budget and returns it with server-assigned fields.
  Future<Either<Failure, Budget>> createBudget(Budget budget);

  /// Updates an existing budget and returns the updated value.
  Future<Either<Failure, Budget>> updateBudget(Budget budget);

  /// Soft-deletes (deactivates) a budget by [id].
  Future<Either<Failure, Unit>> deleteBudget(String id);

  /// Emits the latest list of budgets whenever data changes.
  Stream<Either<Failure, List<Budget>>> watchBudgets({
    required String userId,
  });
}
