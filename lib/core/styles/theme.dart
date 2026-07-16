import 'package:flutter/material.dart';

abstract class Themes {
  Color get primary => const Color(0xFF2E7D32);
  Color get light => const Color(0xFFFFFFFF);
  Color get dark => const Color(0xFF000000);
  Color get transparent => Colors.transparent;

  Color get text => const Color(0xFF1A1A1A);
  Color get hint => const Color(0xFF9E9E9E);
  Color get border => const Color(0xFFE0E0E0);
  Color get divider => const Color(0xFFEEEEEE);

  Color get background => const Color(0xFFF5F5F5);
  Color get surface => const Color(0xFFFFFFFF);

  Color get error => const Color(0xFFE53935);
  Color get success => const Color(0xFF43A047);
  Color get warning => const Color(0xFFFB8C00);
}

class LightTheme extends Themes {}
