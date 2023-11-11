import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
