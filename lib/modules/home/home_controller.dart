import 'package:get/get.dart';

import '../../services/login/login_service.dart';

class HomeController extends GetxController {
  final LoginService _loginService;

  HomeController({required LoginService loginService})
      : _loginService = loginService;

  void handleClick(String value) {
    switch (value) {
      case 'Configurações':
        break;
      case 'Sair':
        _loginService.logout();
        Get.offAllNamed("/login");
        break;
    }
  }
}
