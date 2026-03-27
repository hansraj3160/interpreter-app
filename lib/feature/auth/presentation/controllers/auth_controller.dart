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

  // Observables for state management
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

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
  bool get isInterpreterRole => role.toLowerCase() == 'interpreter';
  bool get requiresExtendedSignupData => isClientRole || isInterpreterRole;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final payload = <String, dynamic>{
      'email': email.trim(),
      'password': password.trim(),
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

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String phone = '',
    List<String> preferredLanguages = const <String>['English'],
    String gender = '',
    String dateOfBirth = '',
  }) async {
    final normalizedRole = role.trim().toLowerCase();

    final payload = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'role': normalizedRole,
    };

    if (requiresExtendedSignupData) {
      payload['phone'] = _normalizePhone(phone);
      payload['preferred_language'] = preferredLanguages
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      payload['gender'] = gender.trim().toLowerCase();
      payload['dateOfBirth'] = dateOfBirth.trim();
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

      if (normalizedRole == 'client') {
        Get.offAllNamed(Routes.CLIENT_DASHBOARD);
      } else if (normalizedRole == 'interpreter') {
        Get.offAllNamed(Routes.INTERPRETER_SETUP_PROFILE);
      } else {
        Get.offNamed(Routes.LOGIN, arguments: {'role': role});
      }
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
      Get.toNamed(
        Routes.VERIFY_OTP,
        arguments: {
          'email': forgotResponse.data.email.isEmpty
              ? email.trim()
              : forgotResponse.data.email,
          'otp': forgotResponse.data.otp,
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


  @override
  void onClose() => super.onClose();
}