import 'package:get/get_navigation/get_navigation.dart';

import '../modules/login/login_bindings.dart';
import '../modules/login/login_page.dart';

class AuthRouters {
  AuthRouters._();
  static final routers = <GetPage>[
    GetPage(
      name: '/login',
      binding: LoginBindings(),
      page: () => const LoginPage(),
    ),
  ];
}
