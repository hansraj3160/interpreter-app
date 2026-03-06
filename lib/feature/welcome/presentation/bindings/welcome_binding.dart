import 'package:get/get.dart';
import 'package:interpreter_app/feature/welcome/presentation/controller/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}