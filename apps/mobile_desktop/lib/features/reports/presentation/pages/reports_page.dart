import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/expense_report.dart';
import '../bloc/report_bloc.dart';
import 'report_detail_page.dart';

/// Main reports page with two tabs:
/// - **Generate**: date range picker + optional category filter + generate button
/// - **Saved**: list of previously saved reports with delete option
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    return BlocProvider(
      create: (_) => getIt<ReportBloc>()
        ..add(ReportEvent.loadSaved(userId: userId)),
      child: _ReportsView(userId: userId),
    );
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView({required this.userId});

  final String userId;

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart_outlined), text: 'Generate'),
            Tab(icon: Icon(Icons.bookmark_outline), text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GenerateTab(userId: widget.userId),
          _SavedTab(userId: widget.userId),
        ],
      ),
    );
  }
}

// ── Generate Tab ──────────────────────────────────────────────────────────────

class _GenerateTab extends StatefulWidget {
  const _GenerateTab({required this.userId});

  final String userId;

  @override
  State<_GenerateTab> createState() => _GenerateTabState();
}

class _GenerateTabState extends State<_GenerateTab> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String? _categoryId;

  final _dateFormat = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listener: (context, state) {
        state.maybeWhen(
          generated: (report) {
            // Navigate to detail page
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ReportDetailPage(report: report),
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Date Range ────────────────────────────────────────────────
              Text(
                'Date Range',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () => _pickDate(context, isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerField(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () => _pickDate(context, isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Quick Range Chips ─────────────────────────────────────────
              Text(
                'Quick Select',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _QuickRangeChip(
                    label: 'This Month',
                    onTap: () => _setQuickRange(
                      DateTime(DateTime.now().year, DateTime.now().month, 1),
                      DateTime.now(),
                    ),
                  ),
                  _QuickRangeChip(
                    label: 'Last Month',
                    onTap: () {
                      final now = DateTime.now();
                      final firstOfLastMonth =
                          DateTime(now.year, now.month - 1, 1);
                      final lastOfLastMonth =
                          DateTime(now.year, now.month, 0);
                      _setQuickRange(firstOfLastMonth, lastOfLastMonth);
                    },
                  ),
                  _QuickRangeChip(
                    label: 'Last 30 Days',
                    onTap: () => _setQuickRange(
                      DateTime.now().subtract(const Duration(days: 30)),
                      DateTime.now(),
                    ),
                  ),
                  _QuickRangeChip(
                    label: 'Last 90 Days',
                    onTap: () => _setQuickRange(
                      DateTime.now().subtract(const Duration(days: 90)),
                      DateTime.now(),
                    ),
                  ),
                  _QuickRangeChip(
                    label: 'This Year',
                    onTap: () => _setQuickRange(
                      DateTime(DateTime.now().year, 1, 1),
                      DateTime.now(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Selected Range Summary ────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${_dateFormat.format(_startDate)} – ${_dateFormat.format(_endDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Generate Button ───────────────────────────────────────────
              FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<ReportBloc>().add(
                              ReportEvent.generate(
                                userId: widget.userId,
                                startDate: _startDate,
                                endDate: _endDate,
                                categoryId: _categoryId,
                              ),
                            );
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.bar_chart),
                label: Text(isLoading ? 'Generating…' : 'Generate Report'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final first = isStart ? DateTime(2020) : _startDate;
    final last = isStart ? _endDate : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _setQuickRange(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }
}

// ── Saved Tab ─────────────────────────────────────────────────────────────────

class _SavedTab extends StatelessWidget {
  const _SavedTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          savedReports: (reports) {
            if (reports.isEmpty) {
              return _EmptySavedState(
                onGenerate: () {
                  // Switch to Generate tab
                  DefaultTabController.of(context).animateTo(0);
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ReportBloc>()
                    .add(ReportEvent.loadSaved(userId: userId));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _SavedReportCard(
                    report: report,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ReportDetailPage(report: report),
                        ),
                      );
                    },
                    onDelete: () => _confirmDelete(context, report.id),
                  );
                },
              ),
            );
          },
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context
                      .read<ReportBloc>()
                      .add(ReportEvent.loadSaved(userId: userId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String reportId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
          'Are you sure you want to delete this saved report? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ReportBloc>()
                  .add(ReportEvent.delete(reportId: reportId));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Saved Report Card ─────────────────────────────────────────────────────────

class _SavedReportCard extends StatelessWidget {
  const _SavedReportCard({
    required this.report,
    required this.onTap,
    required this.onDelete,
  });

  final ExpenseReport report;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '${report.currency} ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.bar_chart_outlined,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dateFormat.format(report.startDate)} – ${dateFormat.format(report.endDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(report.totalAmount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: onDelete,
                tooltip: 'Delete report',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Text(
          dateFormat.format(date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _QuickRangeChip extends StatelessWidget {
  const _QuickRangeChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState({required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 72,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved reports',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a report and save it\nto access it here later.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onGenerate,
            icon: const Icon(Icons.add_chart),
            label: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }
}
