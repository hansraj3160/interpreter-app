import 'package:get/get.dart';
import 'package:interpreter_app/feature/auth/presentation/pages/signup_page.dart';
import 'package:interpreter_app/feature/client_dashboard/presentation/pages/client_dashboard_page.dart';
import 'package:interpreter_app/feature/welcome/presentation/bindings/welcome_binding.dart';
import 'package:interpreter_app/feature/welcome/presentation/page/welcome_page.dart';
import '../feature/auth/presentation/bindings/auth_binding.dart';
import '../feature/auth/presentation/pages/login_page.dart';
import '../feature/client_dashboard/presentation/bindings/client_dashboard_binding.dart';
import '../feature/splash/presentation/bindings/splash_binding.dart';
import '../feature/splash/presentation/pages/splash_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(name: Routes.LOGIN, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(name: Routes.SIGNUP, page: () => const SignupPage(), binding: AuthBinding()),
    GetPage(
      name: Routes.CLIENT_DASHBOARD, 
      page: () => const ClientDashboardPage(), 
     binding: ClientDashboardBinding(),
    ),
  ];
}