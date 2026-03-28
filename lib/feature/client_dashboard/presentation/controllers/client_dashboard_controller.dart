import 'package:get/get.dart';
import 'package:interpreter_app/core/network/api_constants.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/feature/client_dashboard/data/models/interpreter_model.dart';

class ClientDashboardController extends GetxController {
  ClientDashboardController({required DioClient dioClient})
      : _dioClient = dioClient;

  final DioClient _dioClient;

  // Bottom Navigation state
  final RxInt currentIndex = 0.obs;

  // Search / filter state
  final RxString searchQuery = ''.obs;
  final RxString selectedLanguage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;

  // Loading / error state
  final RxBool isLoadingInterpreters = false.obs;
  final RxnString errorMessage = RxnString();

  // Language filter chips (static labels for quick filters)
  final List<String> languages = [
    'Spanish',
    'ASL (Sign)',
    'French',
    'Mandarin',
    'Arabic',
    'German',
  ];

  // Interpreter list
  final RxList<InterpreterModel> interpretersList = <InterpreterModel>[].obs;

  // Backward-compatible aliases
  RxBool get isLoading => isLoadingInterpreters;
  RxList<InterpreterModel> get topInterpreters => interpretersList;
  RxList<InterpreterModel> get topInterpretersList => interpretersList;

  @override
  void onInit() {
    super.onInit();
    fetchInterpreters();
  }

  Future<void> fetchInterpreters({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      interpretersList.clear();
    }

    try {
      isLoadingInterpreters.value = true;
      errorMessage.value = null;

      final queryParams = <String, dynamic>{
        'page': currentPage.value,
        'limit': 10,
        'isOnline': false,
      };

      if (selectedLanguage.value.isNotEmpty) {
        queryParams['language'] = selectedLanguage.value;
      }

      final response = await _dioClient.get(
        ApiConstants.getInterpreters,
        queryParameters: queryParams,
      );

      final outerData = response.data['data'];
      if (outerData is Map<String, dynamic>) {
        totalPages.value =
            (outerData['totalPages'] as num?)?.toInt() ?? 1;
        currentPage.value =
            (outerData['currentPage'] as num?)?.toInt() ?? 1;

        final rawList = outerData['data'];
        final items = rawList is List
            ? rawList.whereType<Map<String, dynamic>>().toList()
            : <Map<String, dynamic>>[];

        interpretersList.assignAll(
          items.map(InterpreterModel.fromJson).toList(),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch interpreters. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingInterpreters.value = false;
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}