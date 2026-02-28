import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.freezed.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadDashboard({
    required String userId,
  }) = LoadDashboard;

  const factory DashboardEvent.refreshDashboard({
    required String userId,
  }) = RefreshDashboard;
}
