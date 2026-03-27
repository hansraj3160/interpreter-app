import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/feature/auth/data/models/auth_response_models.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final DioClient _dioClient = DioClient();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final email = ''.obs;
  final otp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email.value = (args?['email']?.toString() ?? '').trim();
    otp.value = (args?['otp']?.toString() ?? '').trim();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6 || confirmPassword.length < 6) {
      _showError('Password must be at least 6 characters long.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    if (email.value.isEmpty || otp.value.isEmpty) {
      _showError('Reset session is invalid. Please request OTP again.');
      return;
    }

    final payload = <String, dynamic>{
      'email': email.value,
      'otp': otp.value,
      'newPassword': newPassword,
    };

    isLoading.value = true;
    try {
      final response =
          await _dioClient.post(ApiConstants.resetPassword, data: payload);
      final resetResponse = ResetPasswordResponseModel.fromJson(response.data);

      if (!resetResponse.success) {
        throw Exception(
          resetResponse.message.isEmpty
              ? 'Reset password failed'
              : resetResponse.message,
        );
      }

      final message = resetResponse.message.isEmpty
          ? 'Password reset successfully'
          : resetResponse.message;

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      _showError(_readableErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  String _readableErrorMessage(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception:')) {
      return raw.replaceFirst('Exception:', '').trim();
    }
    return raw;
  }

  void _showError(String message) {
    final colorScheme = Get.theme.colorScheme;
    Get.snackbar(
      'Reset Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colorScheme.error,
      colorText: colorScheme.onError,
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
