import 'package:get/get.dart';
import './users_controller.dart';

class UsersBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(UsersController());
  }
}
