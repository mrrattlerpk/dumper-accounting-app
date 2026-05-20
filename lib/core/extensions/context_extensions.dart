import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

/// Useful extensions on BuildContext for cleaner code.
extension BuildContextExtensions on BuildContext {
  /// Access the theme.
  ThemeData get theme => Theme.of(this);

  /// Access the color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access AppLocalizations for translations.
  AppLocalizations get loc => AppLocalizations.of(this);

  /// Shorthand for MediaQuery size.
  Size get screenSize => MediaQuery.of(this).size;

  /// True if device is landscape.
  bool get isLandscape => screenSize.width > screenSize.height;
}