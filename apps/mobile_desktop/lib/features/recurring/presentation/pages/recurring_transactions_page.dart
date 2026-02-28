import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/recurring_bloc.dart';
import '../widgets/recurring_rule_card.dart';

/// Lists all recurring transaction rules for the authenticated user.
class RecurringTransactionsPage extends StatelessWidget {
  const RecurringTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    return BlocProvider(
      create: (_) => getIt<RecurringBloc>()
        ..add(RecurringEvent.load(userId: userId)),
      child: _RecurringView(userId: userId),
    );
  }
}

class _RecurringView extends StatelessWidget {
  const _RecurringView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        actions: [
          // Process due rules manually
          BlocBuilder<RecurringBloc, RecurringState>(
            builder: (context, state) {
              final hasDue = state.maybeWhen(
                loaded: (rules) => rules.any((r) => r.isDue),
                orElse: () => false,
              );

              if (!hasDue) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.play_circle_outline),
                tooltip: 'Process due transactions',
                onPressed: () {
                  context
                      .read<RecurringBloc>()
                      .add(RecurringEvent.processDue(userId: userId));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add recurring rule',
            onPressed: () => context.push(RouteNames.addRecurring),
          ),
        ],
      ),
      body: BlocConsumer<RecurringBloc, RecurringState>(
        listener: (context, state) {
          state.maybeWhen(
            processed: (count) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    count == 0
                        ? 'No transactions to process'
                        : '$count transaction${count == 1 ? '' : 's'} generated',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // Reload after processing
              context
                  .read<RecurringBloc>()
                  .add(RecurringEvent.load(userId: userId));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            saving: () => const Center(child: CircularProgressIndicator()),
            processed: (_) =>
                const Center(child: CircularProgressIndicator()),
            loaded: (rules) {
              if (rules.isEmpty) {
                return _EmptyState(
                  onAdd: () => context.push(RouteNames.addRecurring),
                );
              }

              // Separate due vs upcoming
              final due = rules.where((r) => r.isDue).toList();
              final upcoming = rules.where((r) => !r.isDue).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<RecurringBloc>()
                      .add(RecurringEvent.load(userId: userId));
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    if (due.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Due Now',
                        color: Theme.of(context).colorScheme.error,
                      ),
                      ...due.map(
                        (rule) => RecurringRuleCard(
                          rule: rule,
                          onDelete: () =>
                              _confirmDelete(context, rule.id),
                        ),
                      ),
                    ],
                    if (upcoming.isNotEmpty) ...[
                      _SectionHeader(title: 'Upcoming'),
                      ...upcoming.map(
                        (rule) => RecurringRuleCard(
                          rule: rule,
                          onDelete: () =>
                              _confirmDelete(context, rule.id),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context
                        .read<RecurringBloc>()
                        .add(RecurringEvent.load(userId: userId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<RecurringBloc, RecurringState>(
        builder: (context, state) {
          final isLoaded = state.maybeWhen(
            loaded: (_) => true,
            orElse: () => false,
          );
          if (!isLoaded) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => context.push(RouteNames.addRecurring),
            icon: const Icon(Icons.add),
            label: const Text('New Rule'),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String ruleId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Rule'),
        content: const Text(
          'Are you sure you want to delete this recurring rule? '
          'Existing expenses will not be affected.',
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
                  .read<RecurringBloc>()
                  .add(RecurringEvent.delete(ruleId: ruleId));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.color});

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: color ?? theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.repeat_outlined,
            size: 72,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No recurring rules',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up recurring transactions for bills,\n'
            'subscriptions, and regular expenses.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Rule'),
          ),
        ],
      ),
    );
  }
}
