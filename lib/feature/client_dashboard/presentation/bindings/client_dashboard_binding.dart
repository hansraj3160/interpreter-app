import 'package:get/get.dart';
import 'package:interpreter_app/core/network/dio_client.dart';
import '../controllers/client_dashboard_controller.dart';

class ClientDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    }

    Get.lazyPut<ClientDashboardController>(
      () => ClientDashboardController(dioClient: Get.find<DioClient>()),
    );
  }
}