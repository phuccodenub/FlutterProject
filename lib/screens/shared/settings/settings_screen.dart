// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Theme')),
          _buildThemeRadioOption(
            context,
            ref,
            theme,
            ThemeMode.system,
            'System',
          ),
          _buildThemeRadioOption(context, ref, theme, ThemeMode.light, 'Light'),
          _buildThemeRadioOption(context, ref, theme, ThemeMode.dark, 'Dark'),
          const Divider(),
          const ListTile(title: Text('Language')),
          ListTile(
            title: const Text('Tiếng Việt'),
            onTap: () => context.setLocale(const Locale('vi')),
          ),
          ListTile(
            title: const Text('English'),
            onTap: () => context.setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeRadioOption(
    BuildContext context,
    WidgetRef ref,
    AppThemeState theme,
    ThemeMode value,
    String label,
  ) {
    return ListTile(
      title: Text(label),
      leading: GestureDetector(
        onTap: () => ref.read(appThemeProvider.notifier).setMode(value),
        child: Radio<ThemeMode>(
          value: value,
          groupValue: theme.mode,
          onChanged: (_) {},
        ),
      ),
      onTap: () => ref.read(appThemeProvider.notifier).setMode(value),
    );
  }
}
