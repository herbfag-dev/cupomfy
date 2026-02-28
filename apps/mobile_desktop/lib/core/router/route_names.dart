/// Centralised route path constants.
///
/// Using constants prevents typos and makes refactoring safe.
abstract class RouteNames {
  // ── Auth ──────────────────────────────────────────────────────────────────
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // ── Main shell tabs ───────────────────────────────────────────────────────
  static const dashboard = '/dashboard';
  static const expenses = '/expenses';
  static const chat = '/chat';
  static const settings = '/settings';

  // ── Budgets ───────────────────────────────────────────────────────────────
  static const budgets = '/budgets';
  static const addBudget = '/budgets/add';
  static const budgetDetail = '/budgets/:id';

  // ── Recurring Transactions ────────────────────────────────────────────────
  static const recurring = '/recurring';
  static const addRecurring = '/recurring/add';

  // ── Expense Reports ───────────────────────────────────────────────────────
  static const reports = '/reports';
  static const reportDetail = '/reports/detail';
}
