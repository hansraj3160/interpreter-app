import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/local_storage_helper.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class InterpreterUploadDocsController extends GetxController {
  InterpreterUploadDocsController({
    required DioClient dioClient,
    required LocalStorageHelper localStorageHelper,
  })  : _dioClient = dioClient,
        _localStorageHelper = localStorageHelper;

  final DioClient _dioClient;
  final LocalStorageHelper _localStorageHelper;

  final Rxn<PlatformFile> identityProof = Rxn<PlatformFile>();
  final RxList<PlatformFile> languageCertificates = <PlatformFile>[].obs;
  final Rxn<PlatformFile> resume = Rxn<PlatformFile>();
  final RxBool isLoading = false.obs;

  static const List<String> _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  Future<void> pickIdentityProof() async {
    final file = await _pickSingleFile();
    if (file != null) {
      identityProof.value = file;
    }
  }

  Future<void> pickLanguageCertificates() async {
    final files = await _pickMultipleFiles();
    if (files.isNotEmpty) {
      languageCertificates.addAll(files);
    }
  }

  Future<void> pickResume() async {
    final file = await _pickSingleFile();
    if (file != null) {
      resume.value = file;
    }
  }

  void removeIdentityProof() {
    identityProof.value = null;
  }

  void removeLanguageCertificate(int index) {
    if (index >= 0 && index < languageCertificates.length) {
      languageCertificates.removeAt(index);
    }
  }

  void removeResume() {
    resume.value = null;
  }

  Future<void> uploadDocuments() async {
    if (identityProof.value == null) {
      _showError('Please select an identity proof document.');
      return;
    }

    if (languageCertificates.isEmpty) {
      _showError('Please add at least one language certificate.');
      return;
    }

    if (resume.value == null) {
      _showError('Please select your resume.');
      return;
    }

    isLoading.value = true;

    try {
      final token = await _localStorageHelper.getToken();
      if (token.isEmpty) {
        throw Exception('Authentication token is missing. Please login again.');
      }

      final identityPath = identityProof.value?.path;
      final resumePath = resume.value?.path;
      if (identityPath == null || identityPath.isEmpty) {
        throw Exception('Identity proof file path is invalid.');
      }
      if (resumePath == null || resumePath.isEmpty) {
        throw Exception('Resume file path is invalid.');
      }

      final formData = FormData();
      formData.files.add(
        MapEntry(
          'identity_proof',
          await MultipartFile.fromFile(
            identityPath,
            filename: identityProof.value?.name ?? _fileNameFromPath(identityPath),
          ),
        ),
      );

      for (final certificate in languageCertificates) {
        final certPath = certificate.path;
        if (certPath == null || certPath.isEmpty) {
          continue;
        }
        formData.files.add(
          MapEntry(
            'language_certificate',
            await MultipartFile.fromFile(
              certPath,
              filename: certificate.name,
            ),
          ),
        );
      }

      formData.files.add(
        MapEntry(
          'resume',
          await MultipartFile.fromFile(
            resumePath,
            filename: resume.value?.name ?? _fileNameFromPath(resumePath),
          ),
        ),
      );

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

      final documentStatus = responseData is Map<String, dynamic>
          ? responseData['document_status']?.toString() ?? 'pending'
          : 'pending';

      Get.snackbar(
        'Success',
        'Documents uploaded successfully. Status: $documentStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.INTERPRETER_DASHBOARD);
    } catch (e) {
      _showError(_readableErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<PlatformFile?> _pickSingleFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;
      return result.files.first;
    } catch (e) {
      _showError('Unable to pick file: ${_readableErrorMessage(e)}');
      return null;
    }
  }

  Future<List<PlatformFile>> _pickMultipleFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return const [];
      return result.files;
    } catch (e) {
      _showError('Unable to pick files: ${_readableErrorMessage(e)}');
      return const [];
    }
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
