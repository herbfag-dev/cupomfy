import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _themeModeKey = 'theme_mode';
  static const String _currencyKey = 'currency';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _budgetAlertThresholdKey = 'budget_alert_threshold';
  static const String _weeklyReportEnabledKey = 'weekly_report_enabled';

  @override
  Future<Either<Failure, String>> getThemeMode() async {
    try {
      final mode = _prefs.getString(_themeModeKey) ?? 'system';
      return Right(mode);
    } catch (e, st) {
      AppLogger.error('getThemeMode failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setThemeMode(String mode) async {
    try {
      await _prefs.setString(_themeModeKey, mode);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('setThemeMode failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrency() async {
    try {
      final currency = _prefs.getString(_currencyKey) ?? 'USD';
      return Right(currency);
    } catch (e, st) {
      AppLogger.error('getCurrency failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCurrency(String currency) async {
    try {
      await _prefs.setString(_currencyKey, currency);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('setCurrency failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getNotificationsEnabled() async {
    try {
      final enabled = _prefs.getBool(_notificationsEnabledKey) ?? true;
      return Right(enabled);
    } catch (e, st) {
      AppLogger.error('getNotificationsEnabled failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setNotificationsEnabled(bool enabled) async {
    try {
      await _prefs.setBool(_notificationsEnabledKey, enabled);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('setNotificationsEnabled failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getBudgetAlertThreshold() async {
    try {
      final threshold = _prefs.getDouble(_budgetAlertThresholdKey) ?? 80.0;
      return Right(threshold);
    } catch (e, st) {
      AppLogger.error('getBudgetAlertThreshold failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setBudgetAlertThreshold(double threshold) async {
    try {
      await _prefs.setDouble(_budgetAlertThresholdKey, threshold);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('setBudgetAlertThreshold failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getWeeklyReportEnabled() async {
    try {
      final enabled = _prefs.getBool(_weeklyReportEnabledKey) ?? true;
      return Right(enabled);
    } catch (e, st) {
      AppLogger.error('getWeeklyReportEnabled failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setWeeklyReportEnabled(bool enabled) async {
    try {
      await _prefs.setBool(_weeklyReportEnabledKey, enabled);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('setWeeklyReportEnabled failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportData() async {
    try {
      // TODO: Implement actual data export
      // This would collect all user data and format it (JSON/CSV)
      return const Right('Data export not implemented yet');
    } catch (e, st) {
      AppLogger.error('exportData failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllData() async {
    try {
      // Clear all settings except auth-related
      await _prefs.remove(_themeModeKey);
      await _prefs.remove(_currencyKey);
      await _prefs.remove(_notificationsEnabledKey);
      await _prefs.remove(_budgetAlertThresholdKey);
      await _prefs.remove(_weeklyReportEnabledKey);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('clearAllData failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
