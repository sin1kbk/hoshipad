import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const primaryColor = Color(0xFFFF7400); // Cookpad Orange
    const backgroundColor = Color(0xFFFFFFFF);
    const surfaceColor = Color(0xFFF5F5F5);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: const Color(0xFFFFA04D), // Lighter orange
        surface: backgroundColor,
        background: backgroundColor,
        brightness: Brightness.light,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Noto Sans JP',
        bodyColor: const Color(0xFF333333),
        displayColor: const Color(0xFF333333),
      ).copyWith(
        // フォールバックフォントを設定
        bodyLarge: const TextStyle(
          fontFamily: 'Noto Sans JP',
          fontFamilyFallback: ['Hiragino Sans', 'Hiragino Kaku Gothic ProN', 'Yu Gothic', 'sans-serif'],
          color: Color(0xFF333333),
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Noto Sans JP',
          fontFamilyFallback: ['Hiragino Sans', 'Hiragino Kaku Gothic ProN', 'Yu Gothic', 'sans-serif'],
          color: Color(0xFF333333),
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Noto Sans JP',
          fontFamilyFallback: ['Hiragino Sans', 'Hiragino Kaku Gothic ProN', 'Yu Gothic', 'sans-serif'],
          color: Color(0xFF333333),
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardThemeData(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.white,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF333333),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Noto Sans JP',
          fontFamilyFallback: ['Hiragino Sans', 'Hiragino Kaku Gothic ProN', 'Yu Gothic', 'sans-serif'],
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        iconTheme: IconThemeData(color: Color(0xFF333333)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF999999),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
