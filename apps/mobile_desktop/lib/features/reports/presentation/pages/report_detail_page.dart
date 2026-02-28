import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/expense_report.dart';
import '../bloc/report_bloc.dart';
import '../widgets/category_breakdown_bar.dart';
import '../widgets/report_summary_card.dart';

/// Displays a fully generated [ExpenseReport] with:
/// - Summary card (total, date range, transaction count)
/// - Category breakdown as horizontal bar chart
/// - Daily totals as a simple bar chart
/// - Top 5 expenses list
/// - "Save Report" and "Export CSV" action buttons
class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({
    super.key,
    required this.report,
  });

  final ExpenseReport report;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportBloc>(),
      child: _ReportDetailView(report: report),
    );
  }
}

class _ReportDetailView extends StatelessWidget {
  const _ReportDetailView({required this.report});

  final ExpenseReport report;

  // Palette for category bars (cycles if more than 8 categories)
  static const _barColors = [
    Color(0xFF6750A4),
    Color(0xFF0061A4),
    Color(0xFF006E1C),
    Color(0xFFBA1A1A),
    Color(0xFF7D5700),
    Color(0xFF006874),
    Color(0xFF8B4A00),
    Color(0xFF4A4458),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listener: (context, state) {
        state.maybeWhen(
          exported: (filePath) async {
            // Share the CSV file
            await Share.shareXFiles(
              [XFile(filePath)],
              subject: '${report.title} – CSV Export',
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
          generated: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report saved successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isExporting = state.maybeWhen(
          exporting: () => true,
          orElse: () => false,
        );
        final isSaving = state.maybeWhen(
          saving: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Report Details'),
            actions: [
              if (isExporting || isSaving)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Summary Card ──────────────────────────────────────────────
              ReportSummaryCard(report: report),
              const SizedBox(height: 24),

              // ── Category Breakdown ────────────────────────────────────────
              if (report.categoryBreakdown.isNotEmpty) ...[
                _SectionTitle(title: 'Spending by Category'),
                const SizedBox(height: 12),
                ...report.categoryBreakdown.asMap().entries.map((entry) {
                  final color =
                      _barColors[entry.key % _barColors.length];
                  return CategoryBreakdownBar(
                    breakdown: entry.value,
                    color: color,
                    currency: report.currency,
                  );
                }),
                const SizedBox(height: 24),
              ],

              // ── Daily Totals Chart ────────────────────────────────────────
              if (report.dailyTotals.isNotEmpty) ...[
                _SectionTitle(title: 'Daily Spending'),
                const SizedBox(height: 12),
                _DailyBarChart(
                  dailyTotals: report.dailyTotals,
                  currency: report.currency,
                ),
                const SizedBox(height: 24),
              ],

              // ── Top 5 Expenses ────────────────────────────────────────────
              if (report.topExpenses.isNotEmpty) ...[
                _SectionTitle(title: 'Top Expenses'),
                const SizedBox(height: 8),
                ...report.topExpenses.map(
                  (expense) => _TopExpenseTile(
                    expense: expense,
                    currency: report.currency,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Action Buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isSaving
                          ? null
                          : () => context
                              .read<ReportBloc>()
                              .add(ReportEvent.save(report: report)),
                      icon: const Icon(Icons.bookmark_outline),
                      label: const Text('Save Report'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: isExporting
                          ? null
                          : () => context
                              .read<ReportBloc>()
                              .add(ReportEvent.export(report: report)),
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text('Export CSV'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
    );
  }
}

// ── Daily Bar Chart ───────────────────────────────────────────────────────────

class _DailyBarChart extends StatelessWidget {
  const _DailyBarChart({
    required this.dailyTotals,
    required this.currency,
  });

  final List<DailyTotal> dailyTotals;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxAmount =
        dailyTotals.fold<double>(0, (m, d) => d.amount > m ? d.amount : m);
    final dateFormat = DateFormat('d');
    final currencyFormat = NumberFormat.compactCurrency(
      symbol: '',
      decimalDigits: 0,
    );

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dailyTotals.map((daily) {
          final heightFraction = maxAmount > 0 ? daily.amount / maxAmount : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Amount label (only show if bar is tall enough)
                  if (heightFraction > 0.3)
                    Text(
                      currencyFormat.format(daily.amount),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 2),
                  // Bar
                  Container(
                    height: (heightFraction * 80).clamp(2.0, 80.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Day label
                  Text(
                    dateFormat.format(daily.date),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Top Expense Tile ──────────────────────────────────────────────────────────

class _TopExpenseTile extends StatelessWidget {
  const _TopExpenseTile({
    required this.expense,
    required this.currency,
  });

  final dynamic expense; // Expense entity
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '$currency ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.receipt_outlined,
          color: theme.colorScheme.onSecondaryContainer,
          size: 18,
        ),
      ),
      title: Text(
        expense.title as String,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        dateFormat.format(expense.date as DateTime),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Text(
        currencyFormat.format(expense.amount as double),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
