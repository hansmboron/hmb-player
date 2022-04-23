import 'package:get/get.dart';
import 'package:hmbplayer/modules/settings/settings_controller.dart';

class SettingsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
