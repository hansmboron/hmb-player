import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/ui/theme_extensions.dart';
import 'widgets/home_tile_widget.dart';
import 'widgets/my_drawer_widget.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 45,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'HMB Player',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: controller.handleClick,
            itemBuilder: (BuildContext context) {
              return {'Abrir Audio', 'Sair'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      backgroundColor: context.themeOrange,
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: CachedNetworkImage(
              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/hmb-player.appspot.com/o/abstract2.jpg?alt=media&token=1beefee6-5142-400f-b765-277ec5356c86',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: size.width * 0.04,
            ),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('playlists').orderBy('type').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar playlists!', style: TextStyle(color: Colors.red, fontSize: 30)),
                  );
                } else if (snapshot.data!.size <= 0) {
                  return const Center(
                    child: Text('Erro ao carregar playlists!', style: TextStyle(color: Colors.red, fontSize: 30)),
                  );
                } else {
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    children: snapshot.data!.docs.map((d) {
                      return PlaylistTile(
                        snapshot: d,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
