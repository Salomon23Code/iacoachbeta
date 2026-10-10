import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // COULEURS
  // =========================

  static const Color primary = Color(0xFF006B57);
  static const Color darkGreen = Color(0xFF004D40);
  static const Color lightGreen = Color(0xFFE8F4EF);
  static const Color veryLightGreen = Color(0xFFF2F8F5);

  static const Color white = Colors.white;
  static const Color background = Color(0xFFF8F8F3);

  static const Color textDark = Color(0xFF17352F);
  static const Color textMedium = Color(0xFF52635E);
  static const Color textLight = Color(0xFF8A9792);

  static const Color border = Color(0xFFDCE5E1);

  static const Color success = Color(0xFF18856B);
  static const Color warning = Color(0xFFD98B32);
  static const Color error = Color(0xFFC94C4C);

  // =========================
  // THEME
  // =========================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: darkGreen,
        surface: white,
        error: error,
        onPrimary: white,
        onSecondary: white,
        onSurface: textDark,
      ),

      fontFamily: 'Roboto',

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: border,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: const TextStyle(
          color: textLight,
          fontSize: 14,
        ),

        labelStyle: const TextStyle(
          color: textMedium,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: error,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,

          minimumSize: const Size(
            double.infinity,
            54,
          ),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,

          minimumSize: const Size(
            double.infinity,
            54,
          ),

          side: const BorderSide(
            color: primary,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: white,
        indicatorColor: lightGreen,

        elevation: 0,

        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            size: 24,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),
    );
  }
}