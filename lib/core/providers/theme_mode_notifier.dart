import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_providers.dart';

const String _themeModeKey = 'theme_mode';

final themeModeNotifierProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    ref.listen<AsyncValue<SharedPreferences>>(sharedPreferencesProvider, (previous, next) {
      next.whenData((prefs) {
        final String? saved = prefs.getString(_themeModeKey);
        final ThemeMode loaded = _parseThemeMode(saved);
        if (loaded != state) {
          state = loaded;
        }
      });
    });

    final prefsState = ref.watch(sharedPreferencesProvider);
    return prefsState.maybeWhen(
      data: (prefs) => _parseThemeMode(prefs.getString(_themeModeKey)),
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final ThemeMode nextMode = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    await setThemeMode(nextMode);
  }

  ThemeMode _parseThemeMode(String? raw) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }
}
