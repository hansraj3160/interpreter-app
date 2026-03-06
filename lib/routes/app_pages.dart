import 'package:get/get.dart';
import 'package:interpreter_app/feature/splash/presentation/bindings/splash_binding.dart';
import 'package:interpreter_app/feature/splash/presentation/pages/splash_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._(); // Prevent instantiation

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    // Future features ki GetPage yahan aayengi
  ];
}