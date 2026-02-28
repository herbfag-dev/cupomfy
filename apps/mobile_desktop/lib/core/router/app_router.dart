import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/expenses/presentation/pages/add_expense_page.dart';
import '../../features/expenses/presentation/pages/expense_detail_page.dart';
import '../../features/expenses/presentation/pages/expenses_page.dart';
import '../../features/budgets/presentation/pages/add_budget_page.dart';
import '../../features/budgets/presentation/pages/budgets_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'app_scaffold.dart';
import 'route_names.dart';

abstract class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.dashboard,
    redirect: _redirect,
    refreshListenable: _AuthStateNotifier(GetIt.instance<AuthBloc>()),
    routes: [
      // ─── Auth Routes ─────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // ─── Main Shell ───────────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Expenses Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.expenses,
                name: 'expenses',
                builder: (context, state) => const ExpensesPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'addExpense',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AddExpensePage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'expenseDetail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ExpenseDetailPage(
                      expenseId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Chat Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.chat,
                name: 'chat',
                builder: (context, state) => const ChatPage(),
              ),
            ],
          ),

          // Budgets Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.budgets,
                name: 'budgets',
                builder: (context, state) => const BudgetsPage(),
              ),
            ],
          ),

          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // ─── Budget Modal Routes ──────────────────────────────────────────────
      GoRoute(
        path: RouteNames.addBudget,
        name: 'addBudget',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddBudgetPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.dashboard),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    final isLoading = authState.maybeWhen(
      initial: () => true,
      loading: () => true,
      orElse: () => false,
    );

    final isAuthRoute = state.matchedLocation == RouteNames.login ||
        state.matchedLocation == RouteNames.register ||
        state.matchedLocation == RouteNames.forgotPassword;

    // Still loading — don't redirect
    if (isLoading) return null;

    // Not authenticated and not on auth route — redirect to login
    if (!isAuthenticated && !isAuthRoute) return RouteNames.login;

    // Authenticated and on auth route — redirect to dashboard
    if (isAuthenticated && isAuthRoute) return RouteNames.dashboard;

    return null;
  }
}

/// Notifier that triggers router refresh when auth state changes
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
