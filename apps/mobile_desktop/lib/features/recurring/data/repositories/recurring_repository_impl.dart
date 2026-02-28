import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/recurring_rule.dart';
import '../../domain/repositories/recurring_repository.dart';

@LazySingleton(as: RecurringRepository)
class RecurringRepositoryImpl implements RecurringRepository {
  RecurringRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  // ─── Public API ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<RecurringRule>>> getRules({
    required String userId,
  }) async {
    try {
      final rows = await _supabaseClient
          .from('recurring_rules')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('next_due_date');

      final rules = (rows as List<dynamic>)
          .map((r) => _rowToRule(r as Map<String, dynamic>))
          .toList();

      return Right(rules);
    } catch (e, st) {
      AppLogger.error('getRules failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecurringRule>> getRuleById(String id) async {
    try {
      final rows = await _supabaseClient
          .from('recurring_rules')
          .select()
          .eq('id', id)
          .limit(1);

      final list = rows as List<dynamic>;
      if (list.isEmpty) {
        return const Left(Failure.notFound(message: 'Recurring rule not found'));
      }

      return Right(_rowToRule(list.first as Map<String, dynamic>));
    } catch (e, st) {
      AppLogger.error('getRuleById failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecurringRule>> createRule(RecurringRule rule) async {
    try {
      final now = DateTime.now();
      final newRule = rule.copyWith(
        id: rule.id.isEmpty ? _uuid.v4() : rule.id,
        createdAt: now,
        updatedAt: now,
      );

      await _supabaseClient.from('recurring_rules').insert(_ruleToRow(newRule));

      return Right(newRule);
    } catch (e, st) {
      AppLogger.error('createRule failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecurringRule>> updateRule(RecurringRule rule) async {
    try {
      final updated = rule.copyWith(updatedAt: DateTime.now());
      await _supabaseClient
          .from('recurring_rules')
          .update(_ruleToRow(updated))
          .eq('id', updated.id);

      return Right(updated);
    } catch (e, st) {
      AppLogger.error('updateRule failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRule(String id) async {
    try {
      await _supabaseClient
          .from('recurring_rules')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('deleteRule failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> processDueRules({
    required String userId,
  }) async {
    try {
      final now = DateTime.now();

      // Fetch all active rules that are due
      final rows = await _supabaseClient
          .from('recurring_rules')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .lte('next_due_date', now.toIso8601String());

      final dueRules = (rows as List<dynamic>)
          .map((r) => _rowToRule(r as Map<String, dynamic>))
          .toList();

      if (dueRules.isEmpty) return const Right(0);

      var generated = 0;

      for (final rule in dueRules) {
        // Skip if past end date
        if (rule.endDate != null && now.isAfter(rule.endDate!)) {
          await _supabaseClient
              .from('recurring_rules')
              .update({'is_active': false})
              .eq('id', rule.id);
          continue;
        }

        // Insert the expense
        final expenseId = _uuid.v4();
        await _supabaseClient.from('expenses').insert({
          'id': expenseId,
          'user_id': rule.userId,
          'category_id': rule.categoryId,
          'title': rule.title,
          'amount': rule.amount,
          'currency': rule.currency,
          'date': rule.nextDueDate.toIso8601String(),
          'notes': rule.notes,
          'is_recurring': true,
          'recurrence_rule': rule.frequency.name,
          'parent_id': rule.id,
          'ai_categorized': false,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });

        // Advance the next due date
        final nextDue = rule.nextDueDateAfter(rule.nextDueDate);

        await _supabaseClient
            .from('recurring_rules')
            .update({
              'last_generated_at': rule.nextDueDate.toIso8601String(),
              'next_due_date': nextDue.toIso8601String(),
              'updated_at': now.toIso8601String(),
            })
            .eq('id', rule.id);

        generated++;
      }

      return Right(generated);
    } catch (e, st) {
      AppLogger.error('processDueRules failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<RecurringRule>>> watchRules({
    required String userId,
  }) {
    return _supabaseClient
        .from('recurring_rules')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('next_due_date')
        .map(
          (rows) => Right<Failure, List<RecurringRule>>(
            rows
                .where((r) => r['is_active'] == true)
                .map(_rowToRule)
                .toList(),
          ),
        )
        .handleError(
          (Object e) => Left<Failure, List<RecurringRule>>(
            Failure.server(message: e.toString()),
          ),
        );
  }

  // ─── Private Helpers ───────────────────────────────────────────────────────

  RecurringRule _rowToRule(Map<String, dynamic> row) {
    return RecurringRule(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      categoryId: row['category_id'] as String?,
      title: row['title'] as String,
      amount: (row['amount'] as num).toDouble(),
      currency: row['currency'] as String? ?? 'USD',
      notes: row['notes'] as String?,
      frequency: _parseFrequency(row['frequency'] as String?),
      startDate: DateTime.parse(row['start_date'] as String),
      endDate: row['end_date'] != null
          ? DateTime.parse(row['end_date'] as String)
          : null,
      lastGeneratedAt: row['last_generated_at'] != null
          ? DateTime.parse(row['last_generated_at'] as String)
          : null,
      nextDueDate: DateTime.parse(row['next_due_date'] as String),
      isActive: row['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, dynamic> _ruleToRow(RecurringRule rule) {
    return {
      'id': rule.id,
      'user_id': rule.userId,
      'category_id': rule.categoryId,
      'title': rule.title,
      'amount': rule.amount,
      'currency': rule.currency,
      'notes': rule.notes,
      'frequency': rule.frequency.name,
      'start_date': rule.startDate.toIso8601String(),
      'end_date': rule.endDate?.toIso8601String(),
      'last_generated_at': rule.lastGeneratedAt?.toIso8601String(),
      'next_due_date': rule.nextDueDate.toIso8601String(),
      'is_active': rule.isActive,
      'created_at': rule.createdAt.toIso8601String(),
      'updated_at': rule.updatedAt.toIso8601String(),
    };
  }

  RecurrenceFrequency _parseFrequency(String? value) {
    switch (value) {
      case 'daily':
        return RecurrenceFrequency.daily;
      case 'weekly':
        return RecurrenceFrequency.weekly;
      case 'biweekly':
        return RecurrenceFrequency.biweekly;
      case 'yearly':
        return RecurrenceFrequency.yearly;
      default:
        return RecurrenceFrequency.monthly;
    }
  }
}
