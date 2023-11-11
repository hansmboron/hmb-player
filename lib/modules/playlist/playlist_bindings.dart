import 'package:get/get.dart';
import '../../repositories/home/home_repository.dart';
import '../../repositories/home/home_repository_impl.dart';
import '../../services/home/home_service.dart';
import '../../services/home/home_service_impl.dart';

import './playlist_controller.dart';

class PlaylistBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl());
    Get.lazyPut<HomeService>(() => HomeServiceImpl(homeRepository: Get.find()));
    Get.lazyPut(() => PlaylistController(homeService: Get.find()));
  }
}
