import 'package:get/get.dart';
import 'package:hmbplayer/modules/home/home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(loginService: Get.find()));
  }
}
