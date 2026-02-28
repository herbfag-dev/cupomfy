import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';

abstract class SettingsRepository {
  /// Get the current theme mode (light, dark, system)
  Future<Either<Failure, String>> getThemeMode();

  /// Set the theme mode
  Future<Either<Failure, Unit>> setThemeMode(String mode);

  /// Get the current currency code
  Future<Either<Failure, String>> getCurrency();

  /// Set the currency code
  Future<Either<Failure, Unit>> setCurrency(String currency);

  /// Get notification enabled status
  Future<Either<Failure, bool>> getNotificationsEnabled();

  /// Set notification enabled status
  Future<Either<Failure, Unit>> setNotificationsEnabled(bool enabled);

  /// Get budget alert threshold (percentage)
  Future<Either<Failure, double>> getBudgetAlertThreshold();

  /// Set budget alert threshold
  Future<Either<Failure, Unit>> setBudgetAlertThreshold(double threshold);

  /// Get weekly report enabled status
  Future<Either<Failure, bool>> getWeeklyReportEnabled();

  /// Set weekly report enabled status
  Future<Either<Failure, Unit>> setWeeklyReportEnabled(bool enabled);

  /// Export all data
  Future<Either<Failure, String>> exportData();

  /// Clear all local data
  Future<Either<Failure, Unit>> clearAllData();
}
