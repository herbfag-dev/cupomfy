part of 'recurring_bloc.dart';

@freezed
class RecurringState with _$RecurringState {
  /// No data loaded yet.
  const factory RecurringState.initial() = _Initial;

  /// Fetching rules from the server.
  const factory RecurringState.loading() = _Loading;

  /// Rules loaded successfully.
  const factory RecurringState.loaded(List<RecurringRule> rules) = _Loaded;

  /// A create/update operation is in progress.
  const factory RecurringState.saving() = _Saving;

  /// Due rules were processed; [count] expenses were generated.
  const factory RecurringState.processed(int count) = _Processed;

  /// An error occurred.
  const factory RecurringState.error(String message) = _Error;
}
