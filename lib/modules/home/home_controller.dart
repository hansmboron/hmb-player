import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/models/user_model.dart';

import '../../services/login/login_service.dart';

class HomeController extends GetxController {
  final LoginService _loginService;
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final GetStorage storage = GetStorage();
  RxList userAudios = RxList();

  HomeController({required LoginService loginService})
      : _loginService = loginService;

  bool isAdmin() {
    dynamic admins = jsonDecode(remoteConfig.getValue('admins').asString());
    UserModel user = UserModel.fromMap(storage.read('user'));
    String remoteUid = admins['admins'][0];
    String userUid = user.uid ?? '0';
    log('IsAdmin: ${remoteUid == userUid}');
    return remoteUid == userUid;
  }

  void handleClick(String value) {
    switch (value) {
      case 'Configurações':
        Get.toNamed('/settings');
        break;
      case 'Abrir Audio':
        Get.toNamed('/home/local');
        break;
      case 'Sair':
        logout();
        break;
    }
  }

  Future<void> logout() async {
    await _loginService.logout();
    await storage.erase();
    Get.offAllNamed("/login");
  }
}
