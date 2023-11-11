import 'package:get/get.dart';
import '../modules/users/users_bindings.dart';
import '../modules/users/users_page.dart';

class UsersRouters {
  UsersRouters._();
  static final routers = <GetPage>[
    GetPage(
      name: '/users',
      binding: UsersBindings(),
      page: () => const UsersPage(),
    ),
  ];
}
