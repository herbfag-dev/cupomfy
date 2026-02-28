import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';

part 'budget_bloc.freezed.dart';
part 'budget_event.dart';
part 'budget_state.dart';

@injectable
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc(this._budgetRepository) : super(const BudgetState.initial()) {
    on<_Load>(_onLoad);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
    on<_BudgetsUpdated>(_onBudgetsUpdated);
  }

  final BudgetRepository _budgetRepository;
  StreamSubscription<dynamic>? _watchSubscription;

  // ─── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onLoad(
    _Load event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetState.loading());

    // Cancel any existing watch subscription
    await _watchSubscription?.cancel();

    // Start watching for real-time updates
    _watchSubscription = _budgetRepository
        .watchBudgets(userId: event.userId)
        .listen(
          (result) => result.fold(
            (failure) => add(BudgetEvent.budgetsUpdated(
              budgets: const [],
              errorMessage: failure.displayMessage,
            )),
            (budgets) => add(BudgetEvent.budgetsUpdated(budgets: budgets)),
          ),
        );

    // Also do an immediate fetch so we don't wait for the stream
    final result = await _budgetRepository.getBudgets(userId: event.userId);
    result.fold(
      (failure) => emit(BudgetState.error(failure.displayMessage)),
      (budgets) => emit(BudgetState.loaded(budgets)),
    );
  }

  void _onBudgetsUpdated(
    _BudgetsUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.errorMessage != null) {
      emit(BudgetState.error(event.errorMessage!));
    } else {
      emit(BudgetState.loaded(event.budgets));
    }
  }

  Future<void> _onCreate(
    _Create event,
    Emitter<BudgetState> emit,
  ) async {
    final currentBudgets = state.maybeWhen(
      loaded: (budgets) => budgets,
      orElse: () => <Budget>[],
    );

    emit(const BudgetState.saving());

    final result = await _budgetRepository.createBudget(event.budget);
    result.fold(
      (failure) => emit(BudgetState.error(failure.displayMessage)),
      (created) => emit(BudgetState.loaded([...currentBudgets, created])),
    );
  }

  Future<void> _onUpdate(
    _Update event,
    Emitter<BudgetState> emit,
  ) async {
    final currentBudgets = state.maybeWhen(
      loaded: (budgets) => budgets,
      orElse: () => <Budget>[],
    );

    emit(const BudgetState.saving());

    final result = await _budgetRepository.updateBudget(event.budget);
    result.fold(
      (failure) => emit(BudgetState.error(failure.displayMessage)),
      (updated) {
        final updatedList = currentBudgets
            .map((b) => b.id == updated.id ? updated : b)
            .toList();
        emit(BudgetState.loaded(updatedList));
      },
    );
  }

  Future<void> _onDelete(
    _Delete event,
    Emitter<BudgetState> emit,
  ) async {
    final currentBudgets = state.maybeWhen(
      loaded: (budgets) => budgets,
      orElse: () => <Budget>[],
    );

    final result = await _budgetRepository.deleteBudget(event.budgetId);
    result.fold(
      (failure) => emit(BudgetState.error(failure.displayMessage)),
      (_) {
        final updatedList =
            currentBudgets.where((b) => b.id != event.budgetId).toList();
        emit(BudgetState.loaded(updatedList));
      },
    );
  }

  @override
  Future<void> close() async {
    await _watchSubscription?.cancel();
    return super.close();
  }
}
