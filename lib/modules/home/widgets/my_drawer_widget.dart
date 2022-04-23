import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/modules/home/home_controller.dart';

class MyDrawer extends StatelessWidget {
  final HomeController controller = Get.find();
  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider("https://i.pravatar.cc/200"),
              ),
              accountName: Text('Hans M. boron'),
              accountEmail: Text("hans@gmail.com"),
            ),
            ListTile(
              selected: true,
              leading: const Icon(Icons.home_rounded),
              title: const Text("Home"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Get.back(),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.file_open_rounded),
              title: const Text("Abrir Arquivo"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Get.back();
                Get.toNamed('/home/local');
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text("Configurações"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Get.back();
                Get.toNamed('/settings');
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded),
              title: const Text("Sair"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
