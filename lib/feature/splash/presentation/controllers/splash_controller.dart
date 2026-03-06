import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startApp();
  }

  void _startApp() async {
    // Yahan aage chalkar hum Authentication Token check karenge
    await Future.delayed(const Duration(seconds: 3));
    
    // Auth check ke baad next screen par navigate karein:
    // if (isLoggedIn) {
    //   Get.offAllNamed(Routes.DASHBOARD);
    // } else {
    //   Get.offAllNamed(Routes.LOGIN);
    // }
    
    print("Navigation triggered: Move to Login or Home");
  }
}