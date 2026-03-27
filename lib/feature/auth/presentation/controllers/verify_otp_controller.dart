import 'package:get/get.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class VerifyOtpController extends GetxController {
  final email = ''.obs;
  final otp = ''.obs;
  final expiresAt = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    email.value = (args?['email']?.toString() ?? '').trim();
    otp.value = (args?['otp']?.toString() ?? '').trim();
    expiresAt.value = (args?['expiresAt']?.toString() ?? '').trim();
  }

  void verifyOtp(String enteredOtp) {
    final normalizedOtp = enteredOtp.trim();

    if (normalizedOtp == otp.value) {
      errorMessage.value = null;
      Get.toNamed(
        Routes.RESET_PASSWORD,
        arguments: {
          'email': email.value,
          'otp': otp.value,
          'expiresAt': expiresAt.value,
        },
      );
      return;
    }

    errorMessage.value = 'Invalid OTP. Please enter the correct code.';
    final colorScheme = Get.theme.colorScheme;
    Get.snackbar(
      'Verification Failed',
      errorMessage.value!,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colorScheme.error,
      colorText: colorScheme.onError,
    );
  }
}
