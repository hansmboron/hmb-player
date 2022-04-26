import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/models/user_model.dart';
import 'package:hmbplayer/modules/home/home_controller.dart';

class MyDrawer extends StatelessWidget {
  final HomeController controller = Get.find();
  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _user = UserModel.fromMap(GetStorage().read('user'));

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    _user.photoUrl ?? "https://placekitten.com/150/150"),
              ),
              accountName: Text(_user.name ?? "Nome"),
              accountEmail: Text(_user.email ?? "email@email.com"),
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
              leading: const Icon(Icons.audiotrack_rounded),
              title: const Text("Arquivos locais"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Get.back();
                Get.toNamed('/home/local');
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.playlist_play_rounded),
              title: const Text("Minha Playlist"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () async {
                Get.back();
                Get.toNamed('/home/myplaylist');
              },
            ),
            // const Divider(height: 0),
            // ListTile(
            //   leading: const Icon(Icons.settings_rounded),
            //   title: const Text("Configurações"),
            //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
            //   onTap: () {
            //     Get.back();
            //     Get.toNamed('/settings');
            //   },
            // ),
            if (controller.isAdmin())
              Column(
                children: [
                  const Divider(height: 0),
                  ListTile(
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    leading: const Icon(Icons.people_rounded),
                    title: const Text("Usuários"),
                    trailing: const Icon(Icons.admin_panel_settings_rounded),
                    onTap: () {
                      Get.back();
                      Get.toNamed('/users');
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    leading: const Icon(Icons.add_rounded),
                    title: const Text("Add Audios"),
                    trailing: const Icon(Icons.admin_panel_settings_rounded),
                    onTap: () {
                      Get.back();
                      Get.toNamed('/upload');
                    },
                  ),
                ],
              ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text("Sobre"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/images/logo.png',
                    scale: 7.0,
                  ),
                  applicationName: 'HMB Player',
                  applicationVersion: "1.0.0",
                  applicationLegalese: "Desenvolvido por Hans M. Boron - 2022",
                );
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
