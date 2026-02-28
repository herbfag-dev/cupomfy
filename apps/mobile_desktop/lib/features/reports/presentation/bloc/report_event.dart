part of 'report_bloc.dart';

@freezed
class ReportEvent with _$ReportEvent {
  /// Generate a new report for [userId] over the given date range.
  const factory ReportEvent.generate({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) = _Generate;

  /// Export [report] to a CSV file.
  const factory ReportEvent.export({required ExpenseReport report}) = _Export;

  /// Load all previously saved reports for [userId].
  const factory ReportEvent.loadSaved({required String userId}) = _LoadSaved;

  /// Save [report] to the remote store.
  const factory ReportEvent.save({required ExpenseReport report}) = _Save;

  /// Delete the saved report with [reportId].
  const factory ReportEvent.delete({required String reportId}) = _Delete;
}
