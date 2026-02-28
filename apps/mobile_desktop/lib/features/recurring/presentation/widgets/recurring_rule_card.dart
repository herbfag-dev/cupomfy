import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/recurring_rule.dart';

/// Displays a single recurring rule with its schedule and next due date.
class RecurringRuleCard extends StatelessWidget {
  const RecurringRuleCard({
    super.key,
    required this.rule,
    this.onTap,
    this.onDelete,
  });

  final RecurringRule rule;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: rule.currency == 'USD' ? '\$' : rule.currency,
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Icon ──────────────────────────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _iconColor(theme).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _frequencyIcon(rule.frequency),
                  color: _iconColor(theme),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // ── Details ───────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rule.frequencyLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 12,
                          color: rule.isDue
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rule.isDue
                              ? 'Due: ${dateFormat.format(rule.nextDueDate)}'
                              : 'Next: ${dateFormat.format(rule.nextDueDate)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: rule.isDue
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface.withOpacity(0.5),
                            fontWeight: rule.isDue
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Amount + delete ───────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(rule.amount),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      onPressed: onDelete,
                      color: theme.colorScheme.error,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _iconColor(ThemeData theme) {
    if (rule.isDue) return theme.colorScheme.error;
    return theme.colorScheme.primary;
  }

  IconData _frequencyIcon(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return Icons.today_outlined;
      case RecurrenceFrequency.weekly:
        return Icons.view_week_outlined;
      case RecurrenceFrequency.biweekly:
        return Icons.date_range_outlined;
      case RecurrenceFrequency.monthly:
        return Icons.calendar_month_outlined;
      case RecurrenceFrequency.yearly:
        return Icons.calendar_today_outlined;
    }
  }
}
