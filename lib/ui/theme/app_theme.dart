import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.indigo,
    );
    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}