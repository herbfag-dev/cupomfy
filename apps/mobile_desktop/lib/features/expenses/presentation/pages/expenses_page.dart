import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );

    return BlocProvider(
      create: (_) => getIt<ExpenseBloc>()
        ..add(ExpenseEvent.loadExpenses(userId: userId)),
      child: const _ExpensesView(),
    );
  }
}

class _ExpensesView extends StatefulWidget {
  const _ExpensesView();

  @override
  State<_ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<_ExpensesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<ExpenseBloc>().add(
          ExpenseEvent.searchExpenses(query: query),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          // Expenses List
          Expanded(
            child: BlocConsumer<ExpenseBloc, ExpenseState>(
              listener: (context, state) {
                state.whenOrNull(
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  expenseDeleted: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Expense deleted')),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  expensesLoaded: (
                    expenses,
                    categories,
                    searchQuery,
                    selectedCategoryId,
                    startDate,
                    endDate,
                    sortBy,
                  ) {
                    if (expenses.isEmpty) {
                      return _buildEmptyState(theme);
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ExpenseBloc>().add(
                              const ExpenseEvent.refreshExpenses(),
                            );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          final category = categories.firstWhere(
                            (c) => c.id == expense.categoryId,
                            orElse: () => categories.first,
                          );
                          return _ExpenseCard(
                            expense: expense,
                            category: category,
                            onTap: () => context.push('/expenses/${expense.id}'),
                          );
                        },
                      ),
                    );
                  },
                  expenseLoaded: (_, __) => const SizedBox.shrink(),
                  expenseCreated: (_) => const SizedBox.shrink(),
                  expenseUpdated: (_) => const SizedBox.shrink(),
                  expenseDeleted: () => const SizedBox.shrink(),
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ExpenseBloc>().add(
                                  const ExpenseEvent.refreshExpenses(),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first expense to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _SortBottomSheet(),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.expense,
    required this.category,
    required this.onTap,
  });

  final Expense expense;
  final dynamic category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat.MMMd();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category != null
                      ? Color(category.colorValue).withOpacity(0.2)
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category?.icon != null
                      ? IconData(category.icon, fontFamily: 'MaterialIcons')
                      : Icons.category,
                  color: category != null
                      ? Color(category.colorValue)
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),

              // Expense Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category?.name ?? 'Uncategorized'} • ${dateFormat.format(expense.date)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                currencyFormat.format(expense.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Expenses',
                  style: theme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    context.read<ExpenseBloc>().add(
                          const ExpenseEvent.filterByCategory(
                            categoryId: null,
                          ),
                        );
                    context.read<ExpenseBloc>().add(
                          const ExpenseEvent.filterByDateRange(
                            startDate: null,
                            endDate: null,
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Filter
            Text(
              'Category',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                final categories = state.maybeWhen(
                  expensesLoaded: (_, categories, __, ___, ____, _____, ______) => categories,
                  orElse: () => <dynamic>[],
                );

                return Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: state.maybeWhen(
                        expensesLoaded: (_, __, ___, selectedCategoryId, ____, _____, ______) =>
                            selectedCategoryId == null,
                        orElse: () => true,
                      ),
                      onSelected: (_) {
                        context.read<ExpenseBloc>().add(
                              const ExpenseEvent.filterByCategory(
                                categoryId: null,
                              ),
                            );
                      },
                    ),
                    ...categories.map((category) {
                      final isSelected = state.maybeWhen(
                        expensesLoaded: (_, __, ___, selectedCategoryId, ____, _____, ______) =>
                            selectedCategoryId == category.id,
                        orElse: () => false,
                      );
                      return FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<ExpenseBloc>().add(
                                ExpenseEvent.filterByCategory(
                                  categoryId: category.id,
                                ),
                              );
                        },
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SortBottomSheet extends StatelessWidget {
  const _SortBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortOptions = [
      (ExpenseSortBy.dateDesc, 'Date (Newest first)'),
      (ExpenseSortBy.dateAsc, 'Date (Oldest first)'),
      (ExpenseSortBy.amountDesc, 'Amount (High to low)'),
      (ExpenseSortBy.amountAsc, 'Amount (Low to high)'),
      (ExpenseSortBy.titleAsc, 'Title (A to Z)'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                final currentSortBy = state.maybeWhen(
                  expensesLoaded: (_, __, ___, ____, _____, ______, sortBy) => sortBy,
                  orElse: () => ExpenseSortBy.dateDesc,
                );

                return Column(
                  children: sortOptions.map((option) {
                    final (sortBy, label) = option;
                    return RadioListTile<ExpenseSortBy>(
                      title: Text(label),
                      value: sortBy,
                      groupValue: currentSortBy,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ExpenseBloc>().add(
                                ExpenseEvent.sortExpenses(sortBy: value),
                              );
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
