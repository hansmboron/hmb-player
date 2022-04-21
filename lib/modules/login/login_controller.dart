import 'dart:developer';

import 'package:get/get.dart';

import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/mesages_mixin.dart';
import '../../services/login/login_service.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final LoginService _loginService;
  final loading = false.obs;
  final message = Rxn<MessageModel>();

  LoginController({required LoginService loginService})
      : _loginService = loginService;

  @override
  void onInit() {
    loaderListener(loading);
    messageListener(message);
    super.onInit();
  }

  Future<void> login() async {
    try {
      loading(true); //callable class
      await _loginService.login();
      loading(false);
      message(
        MessageModel(
          title: 'Login Sucesso!',
          message: 'Login Realizado com sucesso!!!',
          type: MessageType.info,
        ),
      );
    } catch (e, s) {
      loading(false);
      log(e.toString());
      log(s.toString());
      message(
        MessageModel(
          title: 'Login Erro!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
    }

    // await 2.seconds.delay();
  }
}
