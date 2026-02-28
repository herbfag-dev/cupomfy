import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class ExpenseDetailPage extends StatefulWidget {
  const ExpenseDetailPage({
    super.key,
    required this.expenseId,
  });

  final String expenseId;

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpenseBloc>()
        ..add(ExpenseEvent.loadExpense(expenseId: widget.expenseId)),
      child: const _ExpenseDetailView(),
    );
  }
}

class _ExpenseDetailView extends StatefulWidget {
  const _ExpenseDetailView();

  @override
  State<_ExpenseDetailView> createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<_ExpenseDetailView> {
  bool _isEditing = false;

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCategoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, Expense expense) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? expense.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSave(Expense expense) {
    final updatedExpense = expense.copyWith(
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      date: _selectedDate ?? expense.date,
      categoryId: _selectedCategoryId ?? expense.categoryId,
      notes: _notesController.text.isEmpty ? null : _notesController.text.trim(),
    );

    context.read<ExpenseBloc>().add(
          ExpenseEvent.updateExpense(expense: updatedExpense),
        );
  }

  void _onDelete(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text(
          'Are you sure you want to delete this expense? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ExpenseBloc>().add(
                    ExpenseEvent.deleteExpense(expenseId: expense.id),
                  );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        state.whenOrNull(
          expenseUpdated: (_) {
            setState(() {
              _isEditing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense updated')),
            );
          },
          expenseDeleted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense deleted')),
            );
            context.pop();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return state.when(
          initial: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          expenseLoaded: (expense, categories) {
            // Initialize controllers if not editing
            if (!_isEditing) {
              _titleController.text = expense.title;
              _amountController.text = expense.amount.toString();
              _notesController.text = expense.notes ?? '';
              _selectedCategoryId = expense.categoryId;
            }

            final category = categories.firstWhere(
              (c) => c.id == expense.categoryId,
              orElse: () => categories.first,
            );

            return Scaffold(
              appBar: AppBar(
                title: Text(_isEditing ? 'Edit Expense' : 'Expense Details'),
                actions: [
                  if (!_isEditing) ...[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _onDelete(expense),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => setState(() => _isEditing = false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : () => _onSave(expense),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ],
              ),
              body: _isEditing
                  ? _buildEditView(expense, categories, theme)
                  : _buildDetailView(expense, category, theme, currencyFormat),
            );
          },
          expensesLoaded: (_, __, ___, ____, _____, ______, _______) =>
              const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          expenseCreated: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          expenseUpdated: (expense) {
            // Reload to get updated data
            context.read<ExpenseBloc>().add(
                  ExpenseEvent.loadExpense(expenseId: expense.id),
                );
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          expenseDeleted: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (message) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(
                            ExpenseEvent.loadExpense(
                              expenseId: widget.expenseId,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailView(
    Expense expense,
    dynamic category,
    ThemeData theme,
    NumberFormat currencyFormat,
  ) {
    final dateFormat = DateFormat.yMMMMd();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Amount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(expense.amount),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Details
          _buildDetailTile(
            icon: Icons.title,
            label: 'Title',
            value: expense.title,
          ),
          _buildDetailTile(
            icon: Icons.category,
            label: 'Category',
            value: category?.name ?? 'Uncategorized',
            iconColor: category != null ? Color(category.colorValue) : null,
          ),
          _buildDetailTile(
            icon: Icons.calendar_today,
            label: 'Date',
            value: dateFormat.format(expense.date),
          ),
          if (expense.notes != null && expense.notes!.isNotEmpty)
            _buildDetailTile(
              icon: Icons.notes,
              label: 'Notes',
              value: expense.notes!,
            ),
          if (expense.tags.isNotEmpty)
            _buildDetailTile(
              icon: Icons.label_outline,
              label: 'Tags',
              value: expense.tags.join(', '),
            ),
          _buildDetailTile(
            icon: Icons.repeat,
            label: 'Recurring',
            value: expense.isRecurring ? 'Yes' : 'No',
          ),

          const SizedBox(height: 24),

          // Created/Updated
          Text(
            'Created: ${dateFormat.format(expense.createdAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            'Last updated: ${dateFormat.format(expense.updatedAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor ?? theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditView(
    Expense expense,
    List<dynamic> categories,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Amount Field
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Title Field
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          DropdownButtonFormField<String?>(
            value: _selectedCategoryId,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('No Category'),
              ),
              ...categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Row(
                    children: [
                      Icon(
                        IconData(category.icon, fontFamily: 'MaterialIcons'),
                        color: Color(category.colorValue),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(category.name),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Date Picker
          InkWell(
            onTap: () => _selectDate(context, expense),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              child: Text(
                DateFormat.yMMMd().format(_selectedDate ?? expense.date),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notes Field
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              prefixIcon: Icon(Icons.notes),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
