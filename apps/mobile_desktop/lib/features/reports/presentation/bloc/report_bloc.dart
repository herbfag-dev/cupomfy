import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/expense_report.dart';
import '../../domain/repositories/report_repository.dart';

part 'report_bloc.freezed.dart';
part 'report_event.dart';
part 'report_state.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc(this._reportRepository) : super(const ReportState.initial()) {
    on<_Generate>(_onGenerate);
    on<_Export>(_onExport);
    on<_LoadSaved>(_onLoadSaved);
    on<_Save>(_onSave);
    on<_Delete>(_onDelete);
  }

  final ReportRepository _reportRepository;

  // ─── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onGenerate(
    _Generate event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportState.loading());

    final result = await _reportRepository.generateReport(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
      categoryId: event.categoryId,
    );

    result.fold(
      (failure) => emit(ReportState.error(failure.displayMessage)),
      (report) => emit(ReportState.generated(report)),
    );
  }

  Future<void> _onExport(
    _Export event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportState.exporting());

    final result = await _reportRepository.exportToCsv(event.report);

    result.fold(
      (failure) => emit(ReportState.error(failure.displayMessage)),
      (filePath) => emit(ReportState.exported(filePath)),
    );
  }

  Future<void> _onLoadSaved(
    _LoadSaved event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportState.loading());

    final result =
        await _reportRepository.getSavedReports(userId: event.userId);

    result.fold(
      (failure) => emit(ReportState.error(failure.displayMessage)),
      (reports) => emit(ReportState.savedReports(reports)),
    );
  }

  Future<void> _onSave(
    _Save event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportState.saving());

    final result = await _reportRepository.saveReport(event.report);

    result.fold(
      (failure) => emit(ReportState.error(failure.displayMessage)),
      (_) => emit(ReportState.generated(event.report)),
    );
  }

  Future<void> _onDelete(
    _Delete event,
    Emitter<ReportState> emit,
  ) async {
    // Capture current saved reports before deleting
    final current = state.maybeWhen(
      savedReports: (reports) => reports,
      orElse: () => <ExpenseReport>[],
    );

    final result = await _reportRepository.deleteReport(event.reportId);

    result.fold(
      (failure) => emit(ReportState.error(failure.displayMessage)),
      (_) {
        final updated =
            current.where((r) => r.id != event.reportId).toList();
        emit(ReportState.savedReports(updated));
      },
    );
  }
}
