import 'package:get/get.dart';
import './upload_controller.dart';

class UploadBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(UploadController());
  }
}
