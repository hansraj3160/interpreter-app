import 'package:get/get.dart';
import '../controllers/interpreter_setup_controller.dart';

class InterpreterSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterpreterSetupController>(() => InterpreterSetupController());
  }
}
