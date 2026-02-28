import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()
        ..add(const SettingsEvent.loadSettings()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          state.whenOrNull(
            exportSuccess: (filePath) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data exported to: $filePath')),
              );
            },
            dataCleared: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
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
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (
              themeMode,
              currency,
              notificationsEnabled,
              budgetAlertThreshold,
              weeklyReportEnabled,
            ) {
              return ListView(
                children: [
                  // Appearance Section
                  _SectionHeader(title: 'Appearance'),
                  _ThemeModeTile(
                    currentMode: themeMode,
                    onChanged: (mode) {
                      context.read<SettingsBloc>().add(
                            SettingsEvent.themeModeChanged(mode: mode),
                          );
                    },
                  ),

                  // Notifications Section
                  _SectionHeader(title: 'Notifications'),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive budget alerts and reminders'),
                    value: notificationsEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            SettingsEvent.notificationsToggled(enabled: value),
                          );
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.assessment_outlined),
                    title: const Text('Weekly Reports'),
                    subtitle: const Text('Get weekly spending summary'),
                    value: weeklyReportEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            SettingsEvent.weeklyReportToggled(enabled: value),
                          );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: const Text('Budget Alert Threshold'),
                    subtitle: Text('${budgetAlertThreshold.toInt()}% of budget'),
                    trailing: SizedBox(
                      width: 150,
                      child: Slider(
                        value: budgetAlertThreshold,
                        min: 50,
                        max: 100,
                        divisions: 10,
                        label: '${budgetAlertThreshold.toInt()}%',
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                                SettingsEvent.budgetAlertThresholdChanged(
                                  threshold: value,
                                ),
                              );
                        },
                      ),
                    ),
                  ),

                  // Preferences Section
                  _SectionHeader(title: 'Preferences'),
                  _CurrencyTile(
                    currentCurrency: currency,
                    onChanged: (currency) {
                      context.read<SettingsBloc>().add(
                            SettingsEvent.currencyChanged(currency: currency),
                          );
                    },
                  ),

                  // Data Section
                  _SectionHeader(title: 'Data'),
                  ListTile(
                    leading: const Icon(Icons.download_outlined),
                    title: const Text('Export Data'),
                    subtitle: const Text('Download your data as JSON'),
                    onTap: () {
                      context.read<SettingsBloc>().add(
                            const SettingsEvent.exportDataRequested(),
                          );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Clear All Data',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    subtitle: const Text('Delete all local settings'),
                    onTap: () => _showClearDataDialog(context),
                  ),

                  // Account Section
                  _SectionHeader(title: 'Account'),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profile'),
                    subtitle: const Text('Manage your account details'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to profile page
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    onTap: () => _showLogoutDialog(context),
                  ),

                  // About Section
                  _SectionHeader(title: 'About'),
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () {
                      // Open terms of service
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                ],
              );
            },
            exportSuccess: (_) => const SizedBox.shrink(),
            dataCleared: () => const SizedBox.shrink(),
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
                      context.read<SettingsBloc>().add(
                            const SettingsEvent.loadSettings(),
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
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your local settings. Your account data will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SettingsBloc>().add(
                    const SettingsEvent.clearDataRequested(),
                  );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(
                    const AuthEvent.logoutRequested(),
                  );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.currentMode,
    required this.onChanged,
  });

  final String currentMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData getIcon(String mode) {
      switch (mode) {
        case 'light':
          return Icons.light_mode;
        case 'dark':
          return Icons.dark_mode;
        default:
          return Icons.brightness_auto;
      }
    }

    String getLabel(String mode) {
      switch (mode) {
        case 'light':
          return 'Light';
        case 'dark':
          return 'Dark';
        default:
          return 'System';
      }
    }

    return ListTile(
      leading: Icon(getIcon(currentMode)),
      title: const Text('Theme'),
      subtitle: Text(getLabel(currentMode)),
      trailing: PopupMenuButton<String>(
        initialValue: currentMode,
        onSelected: onChanged,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'system',
            child: Row(
              children: [
                Icon(Icons.brightness_auto),
                SizedBox(width: 8),
                Text('System'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'light',
            child: Row(
              children: [
                Icon(Icons.light_mode),
                SizedBox(width: 8),
                Text('Light'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'dark',
            child: Row(
              children: [
                Icon(Icons.dark_mode),
                SizedBox(width: 8),
                Text('Dark'),
              ],
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.arrow_drop_down,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currentCurrency,
    required this.onChanged,
  });

  final String currentCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final currencies = {
      'USD': 'US Dollar (\$)',
      'EUR': 'Euro (€)',
      'GBP': 'British Pound (£)',
      'JPY': 'Japanese Yen (¥)',
      'BRL': 'Brazilian Real (R\$)',
      'CAD': 'Canadian Dollar (C\$)',
      'AUD': 'Australian Dollar (A\$)',
    };

    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('Currency'),
      subtitle: Text(currencies[currentCurrency] ?? currentCurrency),
      trailing: PopupMenuButton<String>(
        initialValue: currentCurrency,
        onSelected: onChanged,
        itemBuilder: (context) => currencies.entries
            .map((e) => PopupMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
