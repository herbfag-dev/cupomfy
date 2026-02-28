import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/budget_bloc.dart';
import '../widgets/budget_card.dart';

/// Main screen that lists all budgets for the authenticated user.
class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    return BlocProvider(
      create: (_) => getIt<BudgetBloc>()
        ..add(BudgetEvent.load(userId: userId)),
      child: const _BudgetsView(),
    );
  }
}

class _BudgetsView extends StatelessWidget {
  const _BudgetsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add budget',
            onPressed: () => context.push(RouteNames.addBudget),
          ),
        ],
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            saving: () => const Center(child: CircularProgressIndicator()),
            loaded: (budgets) {
              if (budgets.isEmpty) {
                return _EmptyState(
                  onAdd: () => context.push(RouteNames.addBudget),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final userId =
                      context.read<AuthBloc>().state.maybeWhen(
                            authenticated: (user) => user.id,
                            orElse: () => '',
                          );
                  context
                      .read<BudgetBloc>()
                      .add(BudgetEvent.load(userId: userId));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    return BudgetCard(
                      budget: budget,
                      onTap: () =>
                          context.push('${RouteNames.budgets}/${budget.id}'),
                      onDelete: () => _confirmDelete(context, budget.id),
                    );
                  },
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
                    onPressed: () {
                      final userId =
                          context.read<AuthBloc>().state.maybeWhen(
                                authenticated: (user) => user.id,
                                orElse: () => '',
                              );
                      context
                          .read<BudgetBloc>()
                          .add(BudgetEvent.load(userId: userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          final isLoaded = state.maybeWhen(
            loaded: (_) => true,
            orElse: () => false,
          );
          if (!isLoaded) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => context.push(RouteNames.addBudget),
            icon: const Icon(Icons.add),
            label: const Text('New Budget'),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String budgetId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text(
          'Are you sure you want to delete this budget? This cannot be undone.',
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
                  .read<BudgetBloc>()
                  .add(BudgetEvent.delete(budgetId: budgetId));
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
            Icons.account_balance_wallet_outlined,
            size: 72,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No budgets yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a budget to track your spending\nand stay on top of your finances.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Create Budget'),
          ),
        ],
      ),
    );
  }
}
