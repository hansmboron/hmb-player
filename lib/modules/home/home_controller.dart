import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/login/login_service.dart';

class HomeController extends GetxController {
  final LoginService _loginService;

  HomeController({required LoginService loginService})
      : _loginService = loginService;

  void handleClick(String value) {
    switch (value) {
      case 'Configurações':
        Get.toNamed('/settings');
        break;
      case 'Abrir Local':
        Get.toNamed('/home/local');
        break;
      case 'Sair':
        logout();
        break;
    }
  }

  Future<void> logout() async {
    await _loginService.logout();
    await GetStorage().erase();
    Get.offAllNamed("/login");
  }
}
