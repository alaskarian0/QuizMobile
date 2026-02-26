import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forestGreen,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.forestGreen,
        secondary: AppColors.goldenYellow,
        surface: AppColors.backgroundBeige,
        error: AppColors.errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundBeige,
      textTheme: GoogleFonts.tajawalTextTheme().copyWith(
        displayLarge: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.tajawal(
          color: AppColors.textDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 2,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFF4CAF50),
        secondary: const Color(0xFFFFD54F),
        surface: const Color(0xFF1E1E1E),
        error: const Color(0xFFEF5350),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white70,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.tajawal(
          color: Colors.white70,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white70,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 2,
      ),
    );
  }
}
