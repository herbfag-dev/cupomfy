import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/expense_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../../../expenses/domain/entities/expense.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  // ─── Generate Report ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, ExpenseReport>> generateReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) async {
    try {
      // Build query for expenses in the date range
      var query = _supabaseClient
          .from('expenses')
          .select('*, categories(id, name)')
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String());

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final rows = await query.order('date', ascending: false);
      final expenseRows = rows as List<dynamic>;

      // Parse expenses
      final expenses = expenseRows
          .map((r) => _rowToExpense(r as Map<String, dynamic>))
          .toList();

      // Compute total amount
      final totalAmount =
          expenses.fold<double>(0.0, (sum, e) => sum + e.amount);

      // Compute category breakdown
      final categoryMap = <String, _CategoryAgg>{};
      for (final expense in expenses) {
        final catId = expense.categoryId ?? 'uncategorized';
        final catName = _extractCategoryName(
          expenseRows.firstWhere(
            (r) => (r as Map<String, dynamic>)['id'] == expense.id,
            orElse: () => <String, dynamic>{},
          ) as Map<String, dynamic>,
        );

        if (!categoryMap.containsKey(catId)) {
          categoryMap[catId] = _CategoryAgg(
            categoryId: catId,
            categoryName: catName,
            amount: 0.0,
            count: 0,
          );
        }
        categoryMap[catId]!.amount += expense.amount;
        categoryMap[catId]!.count++;
      }

      final categoryBreakdown = categoryMap.values.map((agg) {
        final percentage =
            totalAmount > 0 ? (agg.amount / totalAmount) * 100 : 0.0;
        return CategoryBreakdown(
          categoryId: agg.categoryId,
          categoryName: agg.categoryName,
          amount: agg.amount,
          percentage: percentage,
          count: agg.count,
        );
      }).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      // Compute daily totals
      final dailyMap = <String, double>{};
      for (final expense in expenses) {
        final dayKey =
            '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}';
        dailyMap[dayKey] = (dailyMap[dayKey] ?? 0.0) + expense.amount;
      }

      final dailyTotals = dailyMap.entries.map((entry) {
        return DailyTotal(
          date: DateTime.parse(entry.key),
          amount: entry.value,
        );
      }).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      // Top 5 expenses by amount
      final sortedExpenses = List<Expense>.from(expenses)
        ..sort((a, b) => b.amount.compareTo(a.amount));
      final topExpenses = sortedExpenses.take(5).toList();

      // Build title
      final title = _buildReportTitle(startDate, endDate);

      final report = ExpenseReport(
        id: _uuid.v4(),
        userId: userId,
        title: title,
        startDate: startDate,
        endDate: endDate,
        totalAmount: totalAmount,
        currency: expenses.isNotEmpty ? expenses.first.currency : 'USD',
        categoryBreakdown: categoryBreakdown,
        dailyTotals: dailyTotals,
        topExpenses: topExpenses,
        generatedAt: DateTime.now(),
      );

      return Right(report);
    } catch (e, st) {
      AppLogger.error('generateReport failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  // ─── Export to CSV ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> exportToCsv(ExpenseReport report) async {
    try {
      final buffer = StringBuffer();

      // CSV header
      buffer.writeln('Date,Title,Category,Amount,Currency,Notes');

      // Fetch full expense data for the report period
      final rows = await _supabaseClient
          .from('expenses')
          .select('*, categories(id, name)')
          .eq('user_id', report.userId)
          .gte('date', report.startDate.toIso8601String())
          .lte('date', report.endDate.toIso8601String())
          .order('date', ascending: false);

      final expenseRows = rows as List<dynamic>;

      for (final row in expenseRows) {
        final r = row as Map<String, dynamic>;
        final date = r['date'] as String? ?? '';
        final title = _escapeCsv(r['title'] as String? ?? '');
        final categoryName = _escapeCsv(_extractCategoryName(r));
        final amount = r['amount']?.toString() ?? '0';
        final currency = r['currency'] as String? ?? 'USD';
        final notes = _escapeCsv(r['notes'] as String? ?? '');

        buffer.writeln('$date,$title,$categoryName,$amount,$currency,$notes');
      }

      // Write to temp file
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'expense_report_${report.startDate.year}${report.startDate.month.toString().padLeft(2, '0')}_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(buffer.toString());

      return Right(file.path);
    } catch (e, st) {
      AppLogger.error('exportToCsv failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  // ─── Saved Reports ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ExpenseReport>>> getSavedReports({
    required String userId,
  }) async {
    try {
      final rows = await _supabaseClient
          .from('expense_reports')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final reports = (rows as List<dynamic>)
          .map((r) => _rowToReport(r as Map<String, dynamic>))
          .toList();

      return Right(reports);
    } catch (e, st) {
      AppLogger.error('getSavedReports failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveReport(ExpenseReport report) async {
    try {
      await _supabaseClient.from('expense_reports').upsert({
        'id': report.id,
        'user_id': report.userId,
        'title': report.title,
        'start_date': report.startDate.toIso8601String(),
        'end_date': report.endDate.toIso8601String(),
        'total_amount': report.totalAmount,
        'currency': report.currency,
        'report_data': jsonEncode(report.toJson()),
        'generated_at': report.generatedAt.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });

      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('saveReport failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReport(String id) async {
    try {
      await _supabaseClient.from('expense_reports').delete().eq('id', id);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('deleteReport failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  // ─── Private Helpers ───────────────────────────────────────────────────────

  Expense _rowToExpense(Map<String, dynamic> row) {
    List<String> tags;
    try {
      final rawTags = row['tags'];
      if (rawTags is List) {
        tags = rawTags.cast<String>();
      } else if (rawTags is String) {
        tags = (jsonDecode(rawTags) as List<dynamic>).cast<String>();
      } else {
        tags = [];
      }
    } catch (_) {
      tags = [];
    }

    return Expense(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      categoryId: row['category_id'] as String?,
      title: row['title'] as String,
      amount: (row['amount'] as num).toDouble(),
      currency: row['currency'] as String? ?? 'USD',
      date: DateTime.parse(row['date'] as String),
      notes: row['notes'] as String?,
      receiptUrl: row['receipt_url'] as String?,
      tags: tags,
      isRecurring: row['is_recurring'] as bool? ?? false,
      recurrenceRule: row['recurrence_rule'] as String?,
      parentId: row['parent_id'] as String?,
      aiCategorized: row['ai_categorized'] as bool? ?? false,
      aiConfidence: row['ai_confidence'] != null
          ? (row['ai_confidence'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  ExpenseReport _rowToReport(Map<String, dynamic> row) {
    final reportData = row['report_data'];
    Map<String, dynamic> data;
    if (reportData is String) {
      data = jsonDecode(reportData) as Map<String, dynamic>;
    } else if (reportData is Map<String, dynamic>) {
      data = reportData;
    } else {
      // Fallback: reconstruct from individual columns
      data = {
        'id': row['id'],
        'userId': row['user_id'],
        'title': row['title'],
        'startDate': row['start_date'],
        'endDate': row['end_date'],
        'totalAmount': row['total_amount'],
        'currency': row['currency'] ?? 'USD',
        'generatedAt': row['generated_at'],
        'categoryBreakdown': [],
        'dailyTotals': [],
        'topExpenses': [],
      };
    }

    return ExpenseReport.fromJson(data);
  }

  String _extractCategoryName(Map<String, dynamic> row) {
    final categories = row['categories'];
    if (categories is Map<String, dynamic>) {
      return categories['name'] as String? ?? 'Uncategorized';
    }
    return 'Uncategorized';
  }

  String _buildReportTitle(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${months[start.month - 1]} ${start.year} Report';
    }
    return '${_formatDate(start)} – ${_formatDate(end)} Report';
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

/// Internal aggregation helper for category breakdown computation.
class _CategoryAgg {
  _CategoryAgg({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.count,
  });

  final String categoryId;
  final String categoryName;
  double amount;
  int count;
}
