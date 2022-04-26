import 'package:get/get.dart';
import 'package:hmbplayer/modules/playlist/playlist_bindings.dart';
import 'package:hmbplayer/modules/playlist/playlist_page.dart';

import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';

class HomeRouters {
  HomeRouters._();
  static final routers = <GetPage>[
    GetPage(
      name: '/home',
      binding: HomeBindings(),
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/home/playlist',
      binding: PlaylistBindings(),
      page: () => PlaylistPage(),
    ),
    GetPage(
      name: '/home/local',
      binding: PlaylistBindings(),
      page: () => PlaylistPage(isLocal: true),
    ),
    GetPage(
      name: '/home/myplaylist',
      binding: PlaylistBindings(),
      page: () => PlaylistPage(isUserPlay: true),
    ),
  ];
}
