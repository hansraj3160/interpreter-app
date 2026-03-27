import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/session_storage.dart';
import 'package:interpreter_app/feature/auth/presentation/controllers/auth_controller.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class InterpreterUploadDocsController extends GetxController {
  final DioClient _dioClient = DioClient();
  final SessionStorage _sessionStorage = SessionStorage();

  final idDocumentPath = ''.obs;
  final certificationPath = ''.obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> pickIdDocument() async {
    final selectedPath = await _pickDocument();
    if (selectedPath != null) {
      idDocumentPath.value = selectedPath;
    }
  }

  Future<void> pickCertificationDocument() async {
    final selectedPath = await _pickDocument();
    if (selectedPath != null) {
      certificationPath.value = selectedPath;
    }
  }

  Future<void> uploadDocuments() async {
    if (idDocumentPath.value.isEmpty || certificationPath.value.isEmpty) {
      _showError('Please select both ID and Certification documents.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final token = await _resolveToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is missing. Please login again.');
      }

      final formData = FormData.fromMap({
        'document': [
          await MultipartFile.fromFile(
            idDocumentPath.value,
            filename: _fileNameFromPath(idDocumentPath.value),
          ),
          await MultipartFile.fromFile(
            certificationPath.value,
            filename: _fileNameFromPath(certificationPath.value),
          ),
        ],
      });

      final response = await _dioClient.post(
        ApiConstants.uploadInterpreterDocs,
        data: formData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      final responseData = response.data;
      final success = responseData is Map<String, dynamic>
          ? responseData['success'] == true
          : false;

      if (!success) {
        final message = responseData is Map<String, dynamic>
            ? (responseData['message']?.toString() ?? 'Document upload failed')
            : 'Document upload failed';
        throw Exception(message);
      }

      Get.snackbar(
        'Success',
        'Documents uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.INTERPRETER_DASHBOARD);
    } catch (e) {
      _showError(_readableErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      return result?.files.single.path;
    } catch (e) {
      _showError('Unable to pick file: ${_readableErrorMessage(e)}');
      return null;
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

  String _readableErrorMessage(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception:')) {
      return raw.replaceFirst('Exception:', '').trim();
    }
    return raw;
  }

  String _fileNameFromPath(String path) {
    final normalized = path.replaceAll('\\\\', '/');
    final segments = normalized.split('/');
    return segments.isNotEmpty ? segments.last : 'document';
  }

  void _showError(String message) {
    errorMessage.value = message;
    final colorScheme = Get.theme.colorScheme;
    Get.snackbar(
      'Upload Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colorScheme.error,
      colorText: colorScheme.onError,
    );
  }
}
