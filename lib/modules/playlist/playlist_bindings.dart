import 'package:get/get.dart';
import './playlist_controller.dart';

class PlaylistBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlaylistController());
  }
}
