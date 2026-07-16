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
        backgroundColor: currentTheme.background,
        foregroundColor: currentTheme.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: currentTheme.text,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: currentTheme.primary,
          foregroundColor: currentTheme.light,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: currentTheme.surface,
        labelStyle: TextStyle(color: currentTheme.hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: currentTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: currentTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: currentTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: currentTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: currentTheme.error, width: 1.5),
        ),
      ),
    );
  }
}
