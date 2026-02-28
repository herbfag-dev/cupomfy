import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/budget.dart';

/// Displays a single budget with a progress bar and spending summary.
class BudgetCard extends StatelessWidget {
  const BudgetCard({
    super.key,
    required this.budget,
    this.onTap,
    this.onDelete,
  });

  final Budget budget;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: budget.currency == 'USD' ? '\$' : budget.currency,
      decimalDigits: 2,
    );

    final progressColor = _progressColor(theme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _periodLabel(budget.period),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      color: theme.colorScheme.error,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Progress bar ─────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: budget.progress,
                  minHeight: 8,
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),

              const SizedBox(height: 8),

              // ── Amounts ──────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currencyFormat.format(budget.spent)} spent',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${currencyFormat.format(budget.remaining)} left of '
                    '${currencyFormat.format(budget.amount)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              // ── Warning chip ─────────────────────────────────────────────
              if (budget.isExceeded || budget.isNearLimit) ...[
                const SizedBox(height: 8),
                _StatusChip(
                  isExceeded: budget.isExceeded,
                  theme: theme,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _progressColor(ThemeData theme) {
    if (budget.isExceeded) return theme.colorScheme.error;
    if (budget.isNearLimit) return Colors.orange;
    return theme.colorScheme.primary;
  }

  String _periodLabel(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return 'Weekly budget';
      case BudgetPeriod.yearly:
        return 'Yearly budget';
      case BudgetPeriod.monthly:
        return 'Monthly budget';
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isExceeded, required this.theme});

  final bool isExceeded;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExceeded
            ? theme.colorScheme.errorContainer
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExceeded ? Icons.warning_rounded : Icons.info_outline,
            size: 14,
            color: isExceeded ? theme.colorScheme.error : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isExceeded ? 'Budget exceeded' : 'Near limit',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isExceeded ? theme.colorScheme.error : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
