import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/expense_report.dart';

/// Contract for expense report data operations.
///
/// Follows the Repository pattern (Clean Architecture / DIP).
abstract class ReportRepository {
  /// Generates a new [ExpenseReport] for [userId] over the given date range.
  ///
  /// Optionally filters by [categoryId].
  /// Computes totals, category breakdown, daily totals, and top 5 expenses.
  Future<Either<Failure, ExpenseReport>> generateReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  });

  /// Exports [report] to a CSV file and returns the local file path.
  ///
  /// The CSV includes columns: Date, Title, Category, Amount, Currency, Notes.
  Future<Either<Failure, String>> exportToCsv(ExpenseReport report);

  /// Returns all previously saved reports for [userId].
  Future<Either<Failure, List<ExpenseReport>>> getSavedReports({
    required String userId,
  });

  /// Persists [report] metadata to the remote `expense_reports` table.
  Future<Either<Failure, Unit>> saveReport(ExpenseReport report);

  /// Permanently deletes the saved report with [id].
  Future<Either<Failure, Unit>> deleteReport(String id);
}
