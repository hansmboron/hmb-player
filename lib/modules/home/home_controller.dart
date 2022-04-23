import 'package:get/get.dart';

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
      case 'Sair':
        logout();
        break;
    }
  }

  void logout() {
    _loginService.logout();
    Get.offAllNamed("/login");
  }
}
