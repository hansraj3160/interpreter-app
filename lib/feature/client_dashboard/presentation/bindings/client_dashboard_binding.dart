import 'package:get/get.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import 'package:interpreter_app/core/utils/local_storage_helper.dart';
import '../controllers/client_dashboard_controller.dart';
import '../controllers/client_profile_controller.dart';

class ClientDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    }

    if (!Get.isRegistered<LocalStorageHelper>()) {
      Get.lazyPut<LocalStorageHelper>(() => LocalStorageHelper(), fenix: true);
    }

    Get.lazyPut<ClientDashboardController>(
      () => ClientDashboardController(dioClient: Get.find<DioClient>()),
    );

    Get.lazyPut<ClientProfileController>(
      () => ClientProfileController(
        dioClient: Get.find<DioClient>(),
        localStorageHelper: Get.find<LocalStorageHelper>(),
      ),
    );
  }
}