import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_event.freezed.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = LoadSettings;

  const factory SettingsEvent.themeModeChanged({
    required String mode,
  }) = ThemeModeChanged;

  const factory SettingsEvent.currencyChanged({
    required String currency,
  }) = CurrencyChanged;

  const factory SettingsEvent.notificationsToggled({
    required bool enabled,
  }) = NotificationsToggled;

  const factory SettingsEvent.budgetAlertThresholdChanged({
    required double threshold,
  }) = BudgetAlertThresholdChanged;

  const factory SettingsEvent.weeklyReportToggled({
    required bool enabled,
  }) = WeeklyReportToggled;

  const factory SettingsEvent.exportDataRequested() = ExportDataRequested;

  const factory SettingsEvent.clearDataRequested() = ClearDataRequested;

  const factory SettingsEvent.logoutRequested() = LogoutRequested;
}
