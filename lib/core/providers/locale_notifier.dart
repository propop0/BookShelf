import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/prefs_keys.dart';
import 'app_providers.dart';

const Locale defaultAppLocale = Locale('en');

final localeNotifierProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    ref.listen<AsyncValue<SharedPreferences>>(sharedPreferencesProvider, (previous, next) {
      next.whenData((SharedPreferences prefs) {
        final Locale loaded = _parseLocale(prefs.getString(PrefsKeys.appLocale));
        if (loaded != state) {
          state = loaded;
        }
      });
    });

    final AsyncValue<SharedPreferences> prefsState = ref.watch(sharedPreferencesProvider);
    return prefsState.maybeWhen(
      data: (SharedPreferences prefs) => _parseLocale(prefs.getString(PrefsKeys.appLocale)),
      orElse: () => defaultAppLocale,
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final SharedPreferences prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(PrefsKeys.appLocale, locale.languageCode);
  }

  Locale _parseLocale(String? code) {
    return switch (code) {
      'uk' => const Locale('uk'),
      'pl' => const Locale('pl'),
      _ => defaultAppLocale,
    };
  }
}
