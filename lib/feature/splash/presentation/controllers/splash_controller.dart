import 'package:get/get.dart';
import '../../../../routes/app_pages.dart'; // Routes import karein

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _initApp();
  }

  void _initApp() async {
    await Future.delayed(const Duration(seconds: 3));
    // Splash ke baad Welcome screen par le jayein
    Get.offAllNamed(Routes.WELCOME); 
  }
}