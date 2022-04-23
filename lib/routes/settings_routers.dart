import 'package:get/get.dart';
import 'package:hmbplayer/modules/settings/settings_bindings.dart';
import 'package:hmbplayer/modules/settings/settings_page.dart';

class SettingsRouters {
  SettingsRouters._();
  static final routers = <GetPage>[
    GetPage(
      name: '/settings',
      binding: SettingsBindings(),
      page: () => const SettingsPage(),
    ),
  ];
}
