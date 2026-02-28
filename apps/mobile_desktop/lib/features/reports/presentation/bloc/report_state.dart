part of 'report_bloc.dart';

@freezed
class ReportState with _$ReportState {
  /// No operation in progress.
  const factory ReportState.initial() = _Initial;

  /// A report is being generated or saved reports are being loaded.
  const factory ReportState.loading() = _Loading;

  /// A report has been successfully generated.
  const factory ReportState.generated(ExpenseReport report) = _Generated;

  /// A CSV export is in progress.
  const factory ReportState.exporting() = _Exporting;

  /// CSV export completed; [filePath] is the path to the exported file.
  const factory ReportState.exported(String filePath) = _Exported;

  /// Saved reports loaded successfully.
  const factory ReportState.savedReports(List<ExpenseReport> reports) =
      _SavedReports;

  /// A save or delete operation is in progress.
  const factory ReportState.saving() = _Saving;

  /// An error occurred.
  const factory ReportState.error(String message) = _Error;
}
