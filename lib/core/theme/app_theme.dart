import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Configuration
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  // Dark Theme (Optional, future requirements ke liye)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}