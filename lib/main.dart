import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

void main() async {
  // Ensure widgets binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Example: Initialize Flutter Secure Storage or Shared Preferences here
  
  runApp(const InterpreterApp());
}

class InterpreterApp extends StatelessWidget {
  const InterpreterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Interpreter Booking System',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Device ki theme ko follow karega
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade, // App-wide route transition
    );
  }
}