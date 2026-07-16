import 'package:flutter/material.dart';

import 'theme.dart';

class AppTheme {
  Themes currentTheme = LightTheme();

  ThemeData getTheme() {
    return ThemeData.light().copyWith(
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: currentTheme.primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: currentTheme.primary,
      ),
      primaryColor: currentTheme.primary,
      colorScheme: ColorScheme.light(
        primary: currentTheme.primary,
        surface: currentTheme.surface,
        error: currentTheme.error,
      ),
      scaffoldBackgroundColor: currentTheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: currentTheme.surface,
        foregroundColor: currentTheme.text,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
