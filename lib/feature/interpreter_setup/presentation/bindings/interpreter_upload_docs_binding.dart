import 'package:get/get.dart';
import '../controllers/interpreter_upload_docs_controller.dart';

class InterpreterUploadDocsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterpreterUploadDocsController>(
      () => InterpreterUploadDocsController(),
    );
  }
}
