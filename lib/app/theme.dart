import 'package:flutter/material.dart';

ThemeData buildSwapItTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardTheme: const CardThemeData(margin: EdgeInsets.all(12)),
  );
}
