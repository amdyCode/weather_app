import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPurple,
      secondary: AppColors.accentCyan,
      surface: AppColors.surfaceDark,
    ),
    textTheme: _buildTextTheme(isDark: true),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    iconTheme: const IconThemeData(color: AppColors.textWhite),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
      iconTheme: const IconThemeData(color: AppColors.textWhite),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primaryLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accentPurple,
      secondary: AppColors.accentCyan,
      surface: AppColors.surfaceLight,
    ),
    textTheme: _buildTextTheme(isDark: false),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    iconTheme: const IconThemeData(color: AppColors.textDark),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark),
    ),
  );

  static TextTheme _buildTextTheme({required bool isDark}) {
    final base = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final headingColor = isDark ? AppColors.textWhite : AppColors.textDark;
    final bodyColor = isDark ? AppColors.textGrey : AppColors.textGreyLight;

    return GoogleFonts.outfitTextTheme(base).copyWith(
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: headingColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: headingColor,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: bodyColor),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: bodyColor),
      labelLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
    );
  }
}
