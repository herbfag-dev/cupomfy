import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/recurring_rule.dart';

/// Contract for recurring-transaction rule data operations.
///
/// Follows the Repository pattern (Clean Architecture / DIP).
abstract class RecurringRepository {
  /// Returns all active recurring rules for [userId].
  Future<Either<Failure, List<RecurringRule>>> getRules({
    required String userId,
  });

  /// Returns a single rule by [id].
  Future<Either<Failure, RecurringRule>> getRuleById(String id);

  /// Persists a new rule and returns it with server-assigned fields.
  Future<Either<Failure, RecurringRule>> createRule(RecurringRule rule);

  /// Updates an existing rule and returns the updated value.
  Future<Either<Failure, RecurringRule>> updateRule(RecurringRule rule);

  /// Soft-deletes (deactivates) a rule by [id].
  Future<Either<Failure, Unit>> deleteRule(String id);

  /// Processes all due rules for [userId]:
  /// - Creates an expense entry for each due rule
  /// - Advances [nextDueDate] to the following occurrence
  /// - Updates [lastGeneratedAt]
  ///
  /// Returns the number of expenses generated.
  Future<Either<Failure, int>> processDueRules({required String userId});

  /// Emits the latest list of rules whenever data changes.
  Stream<Either<Failure, List<RecurringRule>>> watchRules({
    required String userId,
  });
}
