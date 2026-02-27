import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

@LazySingleton(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._db, this._supabaseClient);

  final AppDatabase _db;
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  // ─── Expenses ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Expense>>> getExpenses(
    ExpenseFilter filter,
  ) async {
    try {
      final rows = await _db.watchExpenses(
        userId: filter.userId,
        categoryId: filter.categoryId,
        startDate: filter.startDate,
        endDate: filter.endDate,
      ).first;

      var expenses = rows.map(_rowToExpense).toList();

      // Apply search filter
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        expenses = expenses
            .where(
              (e) =>
                  e.title.toLowerCase().contains(query) ||
                  (e.notes?.toLowerCase().contains(query) ?? false),
            )
            .toList();
      }

      // Apply amount filters
      if (filter.minAmount != null) {
        expenses =
            expenses.where((e) => e.amount >= filter.minAmount!).toList();
      }
      if (filter.maxAmount != null) {
        expenses =
            expenses.where((e) => e.amount <= filter.maxAmount!).toList();
      }

      // Apply sorting
      expenses.sort((a, b) {
        switch (filter.sortBy) {
          case ExpenseSortBy.dateDesc:
            return b.date.compareTo(a.date);
          case ExpenseSortBy.dateAsc:
            return a.date.compareTo(b.date);
          case ExpenseSortBy.amountDesc:
            return b.amount.compareTo(a.amount);
          case ExpenseSortBy.amountAsc:
            return a.amount.compareTo(b.amount);
          case ExpenseSortBy.titleAsc:
            return a.title.compareTo(b.title);
        }
      });

      return Right(expenses);
    } catch (e, st) {
      AppLogger.error('getExpenses failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    try {
      final row = await _db.getExpenseById(id);
      if (row == null) {
        return const Left(Failure.notFound(message: 'Expense not found'));
      }
      return Right(_rowToExpense(row));
    } catch (e, st) {
      AppLogger.error('getExpenseById failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> createExpense(Expense expense) async {
    try {
      final now = DateTime.now();
      final newExpense = expense.copyWith(
        id: expense.id.isEmpty ? _uuid.v4() : expense.id,
        createdAt: now,
        updatedAt: now,
      );

      await _db.upsertExpense(_expenseToCompanion(newExpense, isSynced: false));

      // Sync to Supabase in background
      _syncExpenseToRemote(newExpense);

      return Right(newExpense);
    } catch (e, st) {
      AppLogger.error('createExpense failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      final updated = expense.copyWith(updatedAt: DateTime.now());
      await _db.upsertExpense(_expenseToCompanion(updated, isSynced: false));

      // Sync to Supabase in background
      _syncExpenseToRemote(updated);

      return Right(updated);
    } catch (e, st) {
      AppLogger.error('updateExpense failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpense(String id) async {
    try {
      await _db.softDeleteExpense(id);

      // Delete from Supabase in background
      _deleteExpenseFromRemote(id);

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('deleteExpense failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Expense>>> watchExpenses(
    ExpenseFilter filter,
  ) {
    return _db
        .watchExpenses(
          userId: filter.userId,
          categoryId: filter.categoryId,
          startDate: filter.startDate,
          endDate: filter.endDate,
        )
        .map(
          (rows) => Right<Failure, List<Expense>>(
            rows.map(_rowToExpense).toList(),
          ),
        )
        .handleError(
          (Object e) => Left<Failure, List<Expense>>(
            Failure.cache(message: e.toString()),
          ),
        );
  }

  @override
  Future<Either<Failure, String>> uploadReceipt({
    required String expenseId,
    required String filePath,
  }) async {
    try {
      final fileName = 'receipts/$expenseId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabaseClient.storage.from('receipts').upload(fileName, File(filePath));
      final url = _supabaseClient.storage.from('receipts').getPublicUrl(fileName);
      return Right(url);
    } catch (e, st) {
      AppLogger.error('uploadReceipt failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  // ─── Categories ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    String? userId,
  }) async {
    try {
      final rows = await _db.getCategories(userId: userId);
      return Right(rows.map(_rowToCategory).toList());
    } catch (e, st) {
      AppLogger.error('getCategories failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final now = DateTime.now();
      final newCategory = category.copyWith(
        id: category.id.isEmpty ? _uuid.v4() : category.id,
        createdAt: now,
        updatedAt: now,
      );

      await _db.upsertCategory(_categoryToCompanion(newCategory, isSynced: false));

      // Sync to Supabase in background
      _syncCategoryToRemote(newCategory);

      return Right(newCategory);
    } catch (e, st) {
      AppLogger.error('createCategory failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final updated = category.copyWith(updatedAt: DateTime.now());
      await _db.upsertCategory(_categoryToCompanion(updated, isSynced: false));

      // Sync to Supabase in background
      _syncCategoryToRemote(updated);

      return Right(updated);
    } catch (e, st) {
      AppLogger.error('updateCategory failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _db.deleteCategory(id);

      // Delete from Supabase in background
      _deleteCategoryFromRemote(id);

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('deleteCategory failed', e, st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Category>>> watchCategories({
    String? userId,
  }) {
    return _db
        .watchCategories(userId: userId)
        .map(
          (rows) => Right<Failure, List<Category>>(
            rows.map(_rowToCategory).toList(),
          ),
        )
        .handleError(
          (Object e) => Left<Failure, List<Category>>(
            Failure.cache(message: e.toString()),
          ),
        );
  }

  @override
  Future<Either<Failure, Unit>> syncExpenses() async {
    try {
      final unsynced = await _db.getUnsyncedExpenses();

      for (final row in unsynced) {
        if (row.isDeleted) {
          await _supabaseClient
              .from('expenses')
              .delete()
              .eq('id', row.id);
        } else {
          await _supabaseClient.from('expenses').upsert({
            'id': row.id,
            'user_id': row.userId,
            'category_id': row.categoryId,
            'title': row.title,
            'amount': row.amount,
            'currency': row.currency,
            'date': row.date.toIso8601String(),
            'notes': row.notes,
            'receipt_url': row.receiptUrl,
            'tags': jsonDecode(row.tags) as List<dynamic>,
            'is_recurring': row.isRecurring,
            'recurrence_rule': row.recurrenceRule,
            'parent_id': row.parentId,
            'ai_categorized': row.aiCategorized,
            'ai_confidence': row.aiConfidence,
            'created_at': row.createdAt.toIso8601String(),
            'updated_at': row.updatedAt.toIso8601String(),
          });
        }
        await _db.markExpenseSynced(row.id);
      }

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('syncExpenses failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  // ─── Private Helpers ───────────────────────────────────────────────────────

  Expense _rowToExpense(ExpensesTableData row) {
    List<String> tags;
    try {
      tags = (jsonDecode(row.tags) as List<dynamic>).cast<String>();
    } catch (_) {
      tags = [];
    }

    return Expense(
      id: row.id,
      userId: row.userId,
      categoryId: row.categoryId,
      title: row.title,
      amount: row.amount,
      currency: row.currency,
      date: row.date,
      notes: row.notes,
      receiptUrl: row.receiptUrl,
      tags: tags,
      isRecurring: row.isRecurring,
      recurrenceRule: row.recurrenceRule,
      parentId: row.parentId,
      aiCategorized: row.aiCategorized,
      aiConfidence: row.aiConfidence,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ExpensesTableCompanion _expenseToCompanion(
    Expense expense, {
    required bool isSynced,
  }) {
    return ExpensesTableCompanion.insert(
      id: expense.id,
      userId: expense.userId,
      categoryId: Value(expense.categoryId),
      title: expense.title,
      amount: expense.amount,
      currency: Value(expense.currency),
      date: expense.date,
      notes: Value(expense.notes),
      receiptUrl: Value(expense.receiptUrl),
      tags: Value(jsonEncode(expense.tags)),
      isRecurring: Value(expense.isRecurring),
      recurrenceRule: Value(expense.recurrenceRule),
      parentId: Value(expense.parentId),
      aiCategorized: Value(expense.aiCategorized),
      aiConfidence: Value(expense.aiConfidence),
      createdAt: Value(expense.createdAt),
      updatedAt: Value(expense.updatedAt),
      isSynced: Value(isSynced),
    );
  }

  Category _rowToCategory(CategoriesTableData row) {
    return Category(
      id: row.id,
      userId: row.userId,
      name: row.name,
      icon: row.icon,
      color: row.color,
      isDefault: row.isDefault,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CategoriesTableCompanion _categoryToCompanion(
    Category category, {
    required bool isSynced,
  }) {
    return CategoriesTableCompanion.insert(
      id: category.id,
      userId: category.userId ?? '',
      name: category.name,
      icon: Value(category.icon),
      color: Value(category.color),
      isDefault: Value(category.isDefault),
      sortOrder: Value(category.sortOrder),
      createdAt: Value(category.createdAt),
      updatedAt: Value(category.updatedAt),
      isSynced: Value(isSynced),
    );
  }

  void _syncExpenseToRemote(Expense expense) {
    _supabaseClient.from('expenses').upsert({
      'id': expense.id,
      'user_id': expense.userId,
      'category_id': expense.categoryId,
      'title': expense.title,
      'amount': expense.amount,
      'currency': expense.currency,
      'date': expense.date.toIso8601String(),
      'notes': expense.notes,
      'receipt_url': expense.receiptUrl,
      'tags': expense.tags,
      'is_recurring': expense.isRecurring,
      'recurrence_rule': expense.recurrenceRule,
      'parent_id': expense.parentId,
      'ai_categorized': expense.aiCategorized,
      'ai_confidence': expense.aiConfidence,
      'created_at': expense.createdAt.toIso8601String(),
      'updated_at': expense.updatedAt.toIso8601String(),
    }).then((_) => _db.markExpenseSynced(expense.id)).catchError(
          (Object e) => AppLogger.error('Background sync failed', e),
        );
  }

  void _deleteExpenseFromRemote(String id) {
    _supabaseClient
        .from('expenses')
        .delete()
        .eq('id', id)
        .catchError(
          (Object e) => AppLogger.error('Background delete failed', e),
        );
  }

  void _syncCategoryToRemote(Category category) {
    _supabaseClient.from('categories').upsert({
      'id': category.id,
      'user_id': category.userId,
      'name': category.name,
      'icon': category.icon,
      'color': category.color,
      'is_default': category.isDefault,
      'sort_order': category.sortOrder,
      'created_at': category.createdAt.toIso8601String(),
      'updated_at': category.updatedAt.toIso8601String(),
    }).catchError(
      (Object e) => AppLogger.error('Background category sync failed', e),
    );
  }

  void _deleteCategoryFromRemote(String id) {
    _supabaseClient
        .from('categories')
        .delete()
        .eq('id', id)
        .catchError(
          (Object e) => AppLogger.error('Background category delete failed', e),
        );
  }
}
