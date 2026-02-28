import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_report.dart';

/// A horizontal bar widget that visualises one [CategoryBreakdown] entry.
///
/// Displays the category name, amount, percentage, and a coloured
/// [LinearProgressIndicator] proportional to the category's share of total
/// spending.
class CategoryBreakdownBar extends StatelessWidget {
  const CategoryBreakdownBar({
    super.key,
    required this.breakdown,
    required this.color,
    this.currency = 'USD',
  });

  final CategoryBreakdown breakdown;

  /// Bar fill colour.
  final Color color;

  /// ISO 4217 currency code for formatting the amount.
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '$currency ',
      decimalDigits: 2,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category name + amount row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  breakdown.categoryName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currencyFormat.format(breakdown.amount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Progress bar + percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: breakdown.percentage / 100,
                    minHeight: 8,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 44,
                child: Text(
                  '${breakdown.percentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          // Transaction count
          const SizedBox(height: 2),
          Text(
            '${breakdown.count} transaction${breakdown.count == 1 ? '' : 's'}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
