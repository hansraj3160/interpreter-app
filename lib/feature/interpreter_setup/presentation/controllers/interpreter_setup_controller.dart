import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/session_storage.dart';
import 'package:interpreter_app/feature/auth/presentation/controllers/auth_controller.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class AvailabilityTime {
  final String day;
  final String start;
  final String end;

  const AvailabilityTime({
    required this.day,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}

class InterpreterSetupController extends GetxController {
  final DioClient _dioClient = DioClient();
  final SessionStorage _sessionStorage = SessionStorage();

  final bioController = TextEditingController();
  final languageController = TextEditingController();
  final hourlyRateController = TextEditingController();

  final bio = ''.obs;
  final selectedLanguages = <String>[].obs;
  final hourlyRate = ''.obs;
  final availabilityTimes = <AvailabilityTime>[].obs;

  final daysOfWeek = const <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final selectedDay = ''.obs;
  final startTime = ''.obs;
  final endTime = ''.obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  void addLanguage() {
    final language = languageController.text.trim();
    if (language.isEmpty) return;

    final exists = selectedLanguages.any(
      (item) => item.toLowerCase() == language.toLowerCase(),
    );
    if (!exists) {
      selectedLanguages.add(language);
    }
    languageController.clear();
  }

  void removeLanguage(String language) {
    selectedLanguages.remove(language);
  }

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime.value = picked.format(context);
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime.value = picked.format(context);
    }
  }

  void addAvailability() {
    if (selectedDay.value.isEmpty ||
        startTime.value.isEmpty ||
        endTime.value.isEmpty) {
      final colorScheme = Get.theme.colorScheme;
      Get.snackbar(
        'Incomplete Availability',
        'Please select day, start time, and end time.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colorScheme.error,
        colorText: colorScheme.onError,
      );
      return;
    }

    availabilityTimes.add(
      AvailabilityTime(
        day: selectedDay.value,
        start: startTime.value,
        end: endTime.value,
      ),
    );

    startTime.value = '';
    endTime.value = '';
  }

  void removeAvailability(AvailabilityTime slot) {
    availabilityTimes.remove(slot);
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      bio.value = bioController.text.trim();
      hourlyRate.value = hourlyRateController.text.trim();

      if (bio.value.isEmpty ||
          selectedLanguages.isEmpty ||
          hourlyRate.value.isEmpty ||
          availabilityTimes.isEmpty) {
        throw Exception('Please complete all required profile fields.');
      }

      final token = await _resolveToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is missing. Please login again.');
      }

      final payload = {
        'bio': bio.value.trim(),
        'languages': selectedLanguages
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'availability_time':
            availabilityTimes.map((slot) => slot.toJson()).toList(),
        'hourly_rate': _parseHourlyRate(hourlyRate.value),
      };

      if (kDebugMode) {
        print('📝 [INTERPRETER PROFILE PAYLOAD] $payload');
      }

      final response = await _dioClient.put(
        ApiConstants.updateInterpreterProfile,
        data: payload,
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = response.data;
      final success = responseData is Map<String, dynamic>
          ? responseData['success'] == true
          : false;

      if (!success) {
        final message = responseData is Map<String, dynamic>
            ? (responseData['message']?.toString() ?? 'Profile update failed')
            : 'Profile update failed';
        throw Exception(message);
      }

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.INTERPRETER_UPLOAD_DOCS);
    } catch (e) {
      errorMessage.value = _readableErrorMessage(e);
      final colorScheme = Get.theme.colorScheme;
      Get.snackbar(
        'Update Failed',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colorScheme.error,
        colorText: colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _resolveToken() async {
    final storedToken = await _sessionStorage.getToken();
    if (storedToken.isNotEmpty) return storedToken;

    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().authToken.value;
    }

    return '';
  }

  int _parseHourlyRate(String raw) {
    final normalized = raw.trim().replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(normalized) ?? 0;
    return parsed.round();
  }

  String _readableErrorMessage(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception:')) {
      return raw.replaceFirst('Exception:', '').trim();
    }
    return raw;
  }

  @override
  void onClose() {
    bioController.dispose();
    languageController.dispose();
    hourlyRateController.dispose();
    super.onClose();
  }
}
