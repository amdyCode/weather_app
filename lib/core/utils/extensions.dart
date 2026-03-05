import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/theme/theme_provider.dart';

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension DarkModeExtension on BuildContext {
  bool get isDark => Provider.of<ThemeProvider>(this).isDarkMode;
}

