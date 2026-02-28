import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/recurring_rule.dart';
import '../../domain/repositories/recurring_repository.dart';

part 'recurring_bloc.freezed.dart';
part 'recurring_event.dart';
part 'recurring_state.dart';

@injectable
class RecurringBloc extends Bloc<RecurringEvent, RecurringState> {
  RecurringBloc(this._recurringRepository)
      : super(const RecurringState.initial()) {
    on<_Load>(_onLoad);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
    on<_ProcessDue>(_onProcessDue);
    on<_RulesUpdated>(_onRulesUpdated);
  }

  final RecurringRepository _recurringRepository;
  StreamSubscription<dynamic>? _watchSubscription;

  // ─── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onLoad(
    _Load event,
    Emitter<RecurringState> emit,
  ) async {
    emit(const RecurringState.loading());

    await _watchSubscription?.cancel();

    _watchSubscription = _recurringRepository
        .watchRules(userId: event.userId)
        .listen(
          (result) => result.fold(
            (failure) => add(RecurringEvent.rulesUpdated(
              rules: const [],
              errorMessage: failure.displayMessage,
            )),
            (rules) => add(RecurringEvent.rulesUpdated(rules: rules)),
          ),
        );

    final result =
        await _recurringRepository.getRules(userId: event.userId);
    result.fold(
      (failure) => emit(RecurringState.error(failure.displayMessage)),
      (rules) => emit(RecurringState.loaded(rules)),
    );
  }

  void _onRulesUpdated(
    _RulesUpdated event,
    Emitter<RecurringState> emit,
  ) {
    if (event.errorMessage != null) {
      emit(RecurringState.error(event.errorMessage!));
    } else {
      emit(RecurringState.loaded(event.rules));
    }
  }

  Future<void> _onCreate(
    _Create event,
    Emitter<RecurringState> emit,
  ) async {
    final current = state.maybeWhen(
      loaded: (rules) => rules,
      orElse: () => <RecurringRule>[],
    );

    emit(const RecurringState.saving());

    final result = await _recurringRepository.createRule(event.rule);
    result.fold(
      (failure) => emit(RecurringState.error(failure.displayMessage)),
      (created) => emit(RecurringState.loaded([...current, created])),
    );
  }

  Future<void> _onUpdate(
    _Update event,
    Emitter<RecurringState> emit,
  ) async {
    final current = state.maybeWhen(
      loaded: (rules) => rules,
      orElse: () => <RecurringRule>[],
    );

    emit(const RecurringState.saving());

    final result = await _recurringRepository.updateRule(event.rule);
    result.fold(
      (failure) => emit(RecurringState.error(failure.displayMessage)),
      (updated) {
        final updatedList =
            current.map((r) => r.id == updated.id ? updated : r).toList();
        emit(RecurringState.loaded(updatedList));
      },
    );
  }

  Future<void> _onDelete(
    _Delete event,
    Emitter<RecurringState> emit,
  ) async {
    final current = state.maybeWhen(
      loaded: (rules) => rules,
      orElse: () => <RecurringRule>[],
    );

    final result = await _recurringRepository.deleteRule(event.ruleId);
    result.fold(
      (failure) => emit(RecurringState.error(failure.displayMessage)),
      (_) {
        final updatedList =
            current.where((r) => r.id != event.ruleId).toList();
        emit(RecurringState.loaded(updatedList));
      },
    );
  }

  Future<void> _onProcessDue(
    _ProcessDue event,
    Emitter<RecurringState> emit,
  ) async {
    final result = await _recurringRepository.processDueRules(
      userId: event.userId,
    );
    result.fold(
      (failure) => emit(RecurringState.error(failure.displayMessage)),
      (count) => emit(RecurringState.processed(count)),
    );
  }

  @override
  Future<void> close() async {
    await _watchSubscription?.cancel();
    return super.close();
  }
}
