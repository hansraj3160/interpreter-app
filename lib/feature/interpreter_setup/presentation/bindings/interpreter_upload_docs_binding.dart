import 'package:get/get.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/local_storage_helper.dart';
import '../controllers/interpreter_upload_docs_controller.dart';

class InterpreterUploadDocsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    }

    if (!Get.isRegistered<LocalStorageHelper>()) {
      Get.lazyPut<LocalStorageHelper>(() => LocalStorageHelper(), fenix: true);
    }

    Get.lazyPut<InterpreterUploadDocsController>(
      () => InterpreterUploadDocsController(
        dioClient: Get.find<DioClient>(),
        localStorageHelper: Get.find<LocalStorageHelper>(),
      ),
    );
  }
}
