import 'package:get/get.dart';
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/local_storage_helper.dart';
import 'package:interpreter_app/feature/auth/presentation/controllers/auth_controller.dart';
import 'package:interpreter_app/feature/client_dashboard/data/models/client_profile_model.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class ClientProfileController extends GetxController {
  ClientProfileController({
    required DioClient dioClient,
    required LocalStorageHelper localStorageHelper,
  })  : _dioClient = dioClient,
        _localStorageHelper = localStorageHelper;

  final DioClient _dioClient;
  final LocalStorageHelper _localStorageHelper;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<ClientProfileModel> userData = Rxn<ClientProfileModel>();

  @override
  void onInit() {
    super.onInit();
    // fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final token = await _localStorageHelper.getToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is missing. Please login again.');
      }

      final response = await _dioClient.get(
        ApiConstants.getProfile,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final profileMap = _extractProfileMap(response.data);
      final profile = ClientProfileModel.fromJson(profileMap);

      if (profile.email.isEmpty && profile.name.isEmpty) {
        throw Exception('Unable to load profile data.');
      }

      userData.value = profile;
    } catch (error) {
      final message = _readableError(error);
      errorMessage.value = message;
      userData.value = null;
      final colorScheme = Get.theme.colorScheme;
      Get.snackbar(
        'Profile Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colorScheme.error,
        colorText: colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _localStorageHelper.clearAll();

    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      authController.authToken.value = '';
      authController.currentUser.value = null;
    }

    Get.offAllNamed(Routes.LOGIN);
  }

  Map<String, dynamic>? _extractProfileMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      if (data['user'] is Map<String, dynamic>) {
        return data['user'] as Map<String, dynamic>;
      }
      return data;
    }
    return null;
  }

  String _readableError(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception:')) {
      return raw.replaceFirst('Exception:', '').trim();
    }
    return raw;
  }
}
