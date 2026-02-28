import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = SettingsInitial;

  const factory SettingsState.loading() = SettingsLoading;

  const factory SettingsState.loaded({
    required String themeMode,
    required String currency,
    required bool notificationsEnabled,
    required double budgetAlertThreshold,
    required bool weeklyReportEnabled,
  }) = SettingsLoaded;

  const factory SettingsState.exportSuccess({
    required String filePath,
  }) = ExportSuccess;

  const factory SettingsState.dataCleared() = DataCleared;

  const factory SettingsState.error({
    required String message,
  }) = SettingsError;
}
