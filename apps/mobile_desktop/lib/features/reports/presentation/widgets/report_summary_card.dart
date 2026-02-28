import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_report.dart';

/// A card widget that displays the high-level summary of an [ExpenseReport].
///
/// Shows total amount, date range, number of transactions, and average daily
/// spend.
class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({
    super.key,
    required this.report,
  });

  final ExpenseReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: '${report.currency} ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              report.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Date range
            Text(
              '${dateFormat.format(report.startDate)} – ${dateFormat.format(report.endDate)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),

            // Total amount — large display
            Text(
              currencyFormat.format(report.totalAmount),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Spending',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                _StatChip(
                  icon: Icons.receipt_long_outlined,
                  label: '${report.totalTransactionCount} transactions',
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  icon: Icons.calendar_today_outlined,
                  label: '${report.periodDays} days',
                  color: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _StatChip(
              icon: Icons.trending_up_outlined,
              label:
                  'Avg ${currencyFormat.format(report.averageDailySpend)}/day',
              color: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color.withOpacity(0.8),
              ),
        ),
      ],
    );
  }
}
