import 'package:get/get.dart';

class WelcomeController extends GetxController {
  // Reactive variable to store selected role ('client' or 'interpreter')
  final RxString selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void continueToNext() {
    if (selectedRole.value.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select an account type to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Aage ka logic: Role ke hisaab se Login/Register par bhejein
    print("Proceeding as: ${selectedRole.value}");
    Get.toNamed('/login', arguments: {'role': selectedRole.value});
    // Get.toNamed(Routes.LOGIN, arguments: {'role': selectedRole.value});
  }
}