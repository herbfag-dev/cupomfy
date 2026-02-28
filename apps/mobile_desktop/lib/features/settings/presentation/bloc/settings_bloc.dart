import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._settingsRepository) : super(const SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<CurrencyChanged>(_onCurrencyChanged);
    on<NotificationsToggled>(_onNotificationsToggled);
    on<BudgetAlertThresholdChanged>(_onBudgetAlertThresholdChanged);
    on<WeeklyReportToggled>(_onWeeklyReportToggled);
    on<ExportDataRequested>(_onExportDataRequested);
    on<ClearDataRequested>(_onClearDataRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final themeResult = await _settingsRepository.getThemeMode();
    final currencyResult = await _settingsRepository.getCurrency();
    final notificationsResult = await _settingsRepository.getNotificationsEnabled();
    final thresholdResult = await _settingsRepository.getBudgetAlertThreshold();
    final weeklyReportResult = await _settingsRepository.getWeeklyReportEnabled();

    final results = [
      themeResult,
      currencyResult,
      notificationsResult,
      thresholdResult,
      weeklyReportResult,
    ];

    if (results.any((r) => r.isLeft())) {
      final failure = results.firstWhere((r) => r.isLeft()).fold(
            (f) => f,
            (_) => const Failure.unknown(),
          );
      emit(SettingsState.error(message: _mapFailureToMessage(failure)));
      return;
    }

    emit(SettingsState.loaded(
      themeMode: themeResult.getOrElse(() => 'system'),
      currency: currencyResult.getOrElse(() => 'USD'),
      notificationsEnabled: notificationsResult.getOrElse(() => true),
      budgetAlertThreshold: thresholdResult.getOrElse(() => 80.0),
      weeklyReportEnabled: weeklyReportResult.getOrElse(() => true),
    ));
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _settingsRepository.setThemeMode(event.mode);
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => add(const LoadSettings()),
    );
  }

  Future<void> _onCurrencyChanged(
    CurrencyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _settingsRepository.setCurrency(event.currency);
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => add(const LoadSettings()),
    );
  }

  Future<void> _onNotificationsToggled(
    NotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _settingsRepository.setNotificationsEnabled(event.enabled);
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => add(const LoadSettings()),
    );
  }

  Future<void> _onBudgetAlertThresholdChanged(
    BudgetAlertThresholdChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _settingsRepository.setBudgetAlertThreshold(event.threshold);
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => add(const LoadSettings()),
    );
  }

  Future<void> _onWeeklyReportToggled(
    WeeklyReportToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _settingsRepository.setWeeklyReportEnabled(event.enabled);
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => add(const LoadSettings()),
    );
  }

  Future<void> _onExportDataRequested(
    ExportDataRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final result = await _settingsRepository.exportData();
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (filePath) => emit(SettingsState.exportSuccess(filePath: filePath)),
    );
  }

  Future<void> _onClearDataRequested(
    ClearDataRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final result = await _settingsRepository.clearAllData();
    result.fold(
      (failure) => emit(SettingsState.error(message: _mapFailureToMessage(failure))),
      (_) => emit(const SettingsState.dataCleared()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    // This event is handled by the UI to trigger auth logout
    // The settings bloc doesn't need to do anything here
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
      ai: (message) => message ?? 'AI service error',
    );
  }
}
