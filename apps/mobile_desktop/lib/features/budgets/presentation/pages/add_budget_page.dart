import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';

/// Form page for creating a new budget.
///
/// Pops automatically after a successful save.
class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  BudgetPeriod _period = BudgetPeriod.monthly;
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  DateTime get _endDate {
    switch (_period) {
      case BudgetPeriod.weekly:
        return _startDate.add(const Duration(days: 7));
      case BudgetPeriod.monthly:
        return DateTime(
          _startDate.year,
          _startDate.month + 1,
          _startDate.day,
        );
      case BudgetPeriod.yearly:
        return DateTime(
          _startDate.year + 1,
          _startDate.month,
          _startDate.day,
        );
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    final now = DateTime.now();
    final budget = Budget(
      id: const Uuid().v4(),
      userId: userId,
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      period: _period,
      startDate: _startDate,
      endDate: _endDate,
      createdAt: now,
      updatedAt: now,
    );

    context.read<BudgetBloc>().add(BudgetEvent.create(budget: budget));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (_) => Navigator.of(context).pop(),
          error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: theme.colorScheme.error,
            ),
          ),
          orElse: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Budget')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Name ──────────────────────────────────────────────────
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Budget name',
                  hintText: 'e.g. Groceries',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),

              const SizedBox(height: 16),

              // ── Amount ────────────────────────────────────────────────
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Limit amount',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Amount is required';
                  }
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Period ────────────────────────────────────────────────
              _SectionLabel(label: 'Period'),
              const SizedBox(height: 8),
              SegmentedButton<BudgetPeriod>(
                segments: const [
                  ButtonSegment(
                    value: BudgetPeriod.weekly,
                    label: Text('Weekly'),
                    icon: Icon(Icons.view_week_outlined),
                  ),
                  ButtonSegment(
                    value: BudgetPeriod.monthly,
                    label: Text('Monthly'),
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                  ButtonSegment(
                    value: BudgetPeriod.yearly,
                    label: Text('Yearly'),
                    icon: Icon(Icons.calendar_today_outlined),
                  ),
                ],
                selected: {_period},
                onSelectionChanged: (selection) {
                  setState(() => _period = selection.first);
                },
              ),

              const SizedBox(height: 16),

              // ── Start date ────────────────────────────────────────────
              _SectionLabel(label: 'Start date'),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(
                  '${_startDate.year}-'
                  '${_startDate.month.toString().padLeft(2, '0')}-'
                  '${_startDate.day.toString().padLeft(2, '0')}',
                ),
                subtitle: Text(
                  'Ends: ${_endDate.year}-'
                  '${_endDate.month.toString().padLeft(2, '0')}-'
                  '${_endDate.day.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: TextButton(
                  onPressed: _pickStartDate,
                  child: const Text('Change'),
                ),
              ),

              const SizedBox(height: 32),

              // ── Submit ────────────────────────────────────────────────
              BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  final isSaving = state.maybeWhen(
                    saving: () => true,
                    orElse: () => false,
                  );

                  return FilledButton(
                    onPressed: isSaving ? null : _submit,
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Budget'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
