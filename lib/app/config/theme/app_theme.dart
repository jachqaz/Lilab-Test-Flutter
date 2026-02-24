import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const primaryColor = Color(0xFF6750A4);
    const secondaryColor = Color(0xFF625B71);
    const surfaceColor = Color(0xFFFFFBFE);
    const errorColor = Color(0xFFB3261E);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const primaryColor = Color(0xFFD0BCFF);
    const secondaryColor = Color(0xFFCCC2DC);
    const surfaceColor = Color(0xFF1C1B1F);
    const errorColor = Color(0xFFF2B8B5);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
