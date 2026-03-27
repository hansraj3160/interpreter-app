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

  // Search input state
  final RxString searchQuery = ''.obs;
  final RxString selectedLanguage = ''.obs;
  final RxBool isLoadingInterpreters = false.obs;
  final RxString interpretersError = ''.obs;

  // Dummy list of languages for quick filters
  final List<String> languages = ['Spanish', 'ASL (Sign)', 'French', 'Mandarin', 'Arabic', 'German'];

  final RxList<InterpreterModel> topInterpreters = <InterpreterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInterpreters();
  }

  Future<void> fetchInterpreters() async {
    try {
      isLoadingInterpreters.value = true;
      interpretersError.value = '';

      final response = await _dioClient.get(ApiConstants.getInterpreters);
      final listData = _extractInterpreterList(response.data);

      topInterpreters.assignAll(
        listData.map((item) => InterpreterModel.fromJson(item)).toList(),
      );
    } catch (e) {
      interpretersError.value = e.toString();
      topInterpreters.clear();
    } finally {
      isLoadingInterpreters.value = false;
    }
  }

  List<Map<String, dynamic>> _extractInterpreterList(dynamic responseData) {
    if (responseData is List) {
      return responseData.whereType<Map<String, dynamic>>().toList();
    }

    if (responseData is! Map<String, dynamic>) {
      return const [];
    }

    const listKeys = ['data', 'interpreters', 'results', 'items'];
    for (final key in listKeys) {
      final dynamic value = responseData[key];
      if (value is List) {
        return value.whereType<Map<String, dynamic>>().toList();
      }

      if (value is Map<String, dynamic>) {
        final nestedList = value['interpreters'] ?? value['items'];
        if (nestedList is List) {
          return nestedList.whereType<Map<String, dynamic>>().toList();
        }
      }
    }

    return const [];
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}