import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/recurring_rule.dart';
import '../bloc/recurring_bloc.dart';

/// Form page for creating a new recurring transaction rule.
///
/// Pops automatically after a successful save.
class AddRecurringPage extends StatefulWidget {
  const AddRecurringPage({super.key});

  @override
  State<AddRecurringPage> createState() => _AddRecurringPageState();
}

class _AddRecurringPageState extends State<AddRecurringPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  void _clearEndDate() => setState(() => _endDate = null);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => '',
        );

    final now = DateTime.now();
    final rule = RecurringRule(
      id: const Uuid().v4(),
      userId: userId,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      frequency: _frequency,
      startDate: _startDate,
      endDate: _endDate,
      nextDueDate: _startDate,
      createdAt: now,
      updatedAt: now,
    );

    context.read<RecurringBloc>().add(RecurringEvent.create(rule: rule));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<RecurringBloc, RecurringState>(
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
        appBar: AppBar(title: const Text('New Recurring Rule')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Title ─────────────────────────────────────────────────
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Netflix subscription',
                  prefixIcon: Icon(Icons.repeat_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),

              const SizedBox(height: 16),

              // ── Amount ────────────────────────────────────────────────
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
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

              // ── Notes ─────────────────────────────────────────────────
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              // ── Frequency ─────────────────────────────────────────────
              _SectionLabel(label: 'Frequency'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: RecurrenceFrequency.values.map((freq) {
                  return ChoiceChip(
                    label: Text(_frequencyLabel(freq)),
                    selected: _frequency == freq,
                    onSelected: (_) => setState(() => _frequency = freq),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // ── Start date ────────────────────────────────────────────
              _SectionLabel(label: 'Start date'),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(_formatDate(_startDate)),
                trailing: TextButton(
                  onPressed: _pickStartDate,
                  child: const Text('Change'),
                ),
              ),

              // ── End date (optional) ───────────────────────────────────
              _SectionLabel(label: 'End date (optional)'),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_busy_outlined),
                title: Text(
                  _endDate != null ? _formatDate(_endDate!) : 'No end date',
                  style: _endDate == null
                      ? theme.textTheme.bodyMedium?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.4),
                        )
                      : null,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_endDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: _clearEndDate,
                        tooltip: 'Remove end date',
                      ),
                    TextButton(
                      onPressed: _pickEndDate,
                      child: Text(_endDate != null ? 'Change' : 'Set'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Submit ────────────────────────────────────────────────
              BlocBuilder<RecurringBloc, RecurringState>(
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
                        : const Text('Create Rule'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String _frequencyLabel(RecurrenceFrequency freq) {
    switch (freq) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Biweekly';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
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
