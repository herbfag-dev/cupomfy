part of 'recurring_bloc.dart';

@freezed
class RecurringEvent with _$RecurringEvent {
  /// Load (and watch) all recurring rules for [userId].
  const factory RecurringEvent.load({required String userId}) = _Load;

  /// Create a new recurring rule.
  const factory RecurringEvent.create({required RecurringRule rule}) = _Create;

  /// Update an existing recurring rule.
  const factory RecurringEvent.update({required RecurringRule rule}) = _Update;

  /// Delete (deactivate) a rule by [ruleId].
  const factory RecurringEvent.delete({required String ruleId}) = _Delete;

  /// Process all due rules for [userId] and generate expense entries.
  const factory RecurringEvent.processDue({required String userId}) =
      _ProcessDue;

  /// Internal: emitted by the real-time stream subscription.
  const factory RecurringEvent.rulesUpdated({
    required List<RecurringRule> rules,
    String? errorMessage,
  }) = _RulesUpdated;
}
