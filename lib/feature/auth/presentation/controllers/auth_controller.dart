import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/session_storage.dart';
import 'package:interpreter_app/feature/auth/data/models/auth_response_models.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class AuthController extends GetxController {
  final DioClient _dioClient = DioClient();
  final SessionStorage _sessionStorage = SessionStorage();
  final RxString authToken = ''.obs;
  final Rxn<AuthUserModel> currentUser = Rxn<AuthUserModel>();

  // Role aayega Welcome screen se
  String role = '';

  // Text Controllers
  final emailController = TextEditingController(text: "abc@gmail.com");
  final passwordController = TextEditingController(text: "password123");
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final nameController = TextEditingController(); // For Signup
  final phoneController = TextEditingController();
  final preferredLanguageController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // Observables for state management
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;
  final selectedGender = ''.obs;

  List<String> get genderOptions => const ['male', 'female', 'other'];

  @override
  void onInit() {
    super.onInit();
    // Welcome screen se bheja gaya argument capture karein
    if (Get.arguments != null && Get.arguments['role'] != null) {
      role = Get.arguments['role'];
    } else {
      role = 'client'; // fallback
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  bool get isClientRole => role.toLowerCase() == 'client';

  Future<void> pickDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked == null) return;
    dateOfBirthController.text =
        '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> login() async {
    final payload = <String, dynamic>{
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    isLoading.value = true;
    try {
      if (kDebugMode) {
        final safePayload = Map<String, dynamic>.from(payload)
          ..update('password', (_) => '***');
        print('📝 [LOGIN PAYLOAD] $safePayload');
      }

      final response = await _dioClient.post(ApiConstants.login, data: payload);
      final loginResponse = LoginResponseModel.fromJson(response.data);

      if (!loginResponse.success) {
        throw Exception(
          loginResponse.message.isEmpty ? 'Login failed' : loginResponse.message,
        );
      }

      final message =
          loginResponse.message.isEmpty ? 'Login successful' : loginResponse.message;
      final user = loginResponse.data.user;
      final userRole = user.role.trim().toLowerCase().isEmpty
          ? role
          : user.role.trim().toLowerCase();
      final token = loginResponse.data.token;

      if (token.isEmpty) {
        throw Exception('Login token is missing from response');
      }

      authToken.value = token;
      currentUser.value = user;

      await _sessionStorage.saveLoginSession(
        token: token,
        loginTime: DateTime.now(),
        role: userRole,
      );

      if (kDebugMode) {
        print('✅ [LOGIN ROLE] $userRole');
        print('🔐 [TOKEN RECEIVED] ${token.isNotEmpty}');
      }

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

      if (userRole == 'client') {
        Get.offAllNamed(Routes.CLIENT_DASHBOARD);
      } else {
        // Future mein interpreter dashboard yahan aayega
        // Get.offAllNamed('/interpreter-dashboard');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [LOGIN EXCEPTION] $e');
      }
      Get.snackbar(
        'Login Failed',
        _readableErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    final normalizedRole = role.trim().toLowerCase();

    final payload = <String, dynamic>{
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'role': normalizedRole,
    };

    if (normalizedRole == 'client') {
      payload['phone'] = _normalizePhone(phoneController.text);
      payload['preferred_language'] = _parsePreferredLanguages(
        preferredLanguageController.text,
      );
      payload['gender'] = selectedGender.value.trim().toLowerCase();
      payload['dateOfBirth'] = dateOfBirthController.text.trim();
    }

    isLoading.value = true;
    try {
      if (kDebugMode) {
        final safePayload = Map<String, dynamic>.from(payload)
          ..update('password', (_) => '***');
        print('📝 [SIGNUP PAYLOAD] $safePayload');
      }

        final response = await _dioClient.post(ApiConstants.register, data: payload);
        final signupResponse = SignupResponseModel.fromJson(response.data);

        if (!signupResponse.success) {
        throw Exception(
          signupResponse.message.isEmpty
            ? 'Signup failed'
            : signupResponse.message,
        );
        }

        final message = signupResponse.message.isEmpty
          ? 'Account created successfully!'
          : signupResponse.message;
        final userId = signupResponse.data.userId == 0
          ? null
          : signupResponse.data.userId;

      Get.snackbar(
        'Success',
        userId == null ? message : '$message (User ID: $userId)',
        snackPosition: SnackPosition.BOTTOM,
      );
      _clearSignupFields();
      Get.offNamed(Routes.LOGIN, arguments: {'role': role});
    } catch (e) {
      if (kDebugMode) {
        print('❌ [SIGNUP EXCEPTION] $e');
      }
      Get.snackbar(
        'Signup Failed',
        _readableErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<String> _parsePreferredLanguages(String raw) {
    final parsed = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return parsed;
  }

  String _normalizePhone(String raw) {
    return raw.replaceAll(RegExp(r'\s+'), '');
  }

  String _readableErrorMessage(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception:')) {
      return raw.replaceFirst('Exception:', '').trim();
    }
    return raw;
  }

  void _clearSignupFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    preferredLanguageController.clear();
    dateOfBirthController.clear();
    selectedGender.value = '';
    isPasswordHidden.value = true;
    isConfirmPasswordHidden.value = true;
  }

  void clearResetPasswordFields() {
    otpController.clear();
    newPasswordController.clear();
    isPasswordHidden.value = true;
  }

  void forgotPassword(String email) async {
    final payload = <String, dynamic>{
      'email': email.trim(),
    };

    isLoading.value = true;
    try {
      if (kDebugMode) {
        print('📝 [FORGOT PASSWORD PAYLOAD] $payload');
      }

      final response =
          await _dioClient.post(ApiConstants.forgotPassword, data: payload);
      final forgotResponse = ForgotPasswordResponseModel.fromJson(response.data);

      if (!forgotResponse.success) {
        throw Exception(
          forgotResponse.message.isEmpty
              ? 'Forgot password request failed'
              : forgotResponse.message,
        );
      }

      final message = forgotResponse.message.isEmpty
          ? 'OTP generated successfully'
          : forgotResponse.message;

      if (kDebugMode) {
        print(
          '✅ [FORGOT PASSWORD RESPONSE] otp=${forgotResponse.data.otp}, expiresAt=${forgotResponse.data.expiresAt}, email=${forgotResponse.data.email}',
        );
      }

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      clearResetPasswordFields();
      Get.toNamed(
        Routes.RESET_PASSWORD,
        arguments: {
          'email': forgotResponse.data.email.isEmpty
              ? email.trim()
              : forgotResponse.data.email,
          'expiresAt': forgotResponse.data.expiresAt,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ [FORGOT PASSWORD EXCEPTION] $e');
      }
      Get.snackbar(
        'Request Failed',
        _readableErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final payload = <String, dynamic>{
      'email': email.trim(),
      'otp': otp.trim(),
      'newPassword': newPassword.trim(),
    };

    isLoading.value = true;
    try {
      if (kDebugMode) {
        final safePayload = Map<String, dynamic>.from(payload)
          ..update('newPassword', (_) => '***');
        print('📝 [RESET PASSWORD PAYLOAD] $safePayload');
      }

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
      clearResetPasswordFields();
      Get.offAllNamed(Routes.LOGIN, arguments: {'role': role});
    } catch (e) {
      if (kDebugMode) {
        print('❌ [RESET PASSWORD EXCEPTION] $e');
      }
      Get.snackbar(
        'Reset Failed',
        _readableErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    preferredLanguageController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}