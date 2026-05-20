import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider for managing the app's locale at runtime.
/// Defaults to English ('en') until overridden by saved settings.
final localeProvider = StateProvider<Locale>((ref) {
  // Default to English.
  // The initial locale will be overwritten when settings are loaded from Isar.
  return const Locale('en');
});

/// Helper function to toggle between English and Urdu.
void toggleLocale(WidgetRef ref) {
  final current = ref.read(localeProvider);
  final newLocale = current.languageCode == 'en'
      ? const Locale('ur')
      : const Locale('en');
  ref.read(localeProvider.notifier).state = newLocale;
}

/// Persist locale change to Isar via SettingsRepository.
/// This function will be called from the settings screen.
Future<void> saveLocaleToSettings(Locale locale) async {
  // The actual saving logic will be implemented in the settings repository.
  // For now, it's a placeholder to show separation of concerns.
}