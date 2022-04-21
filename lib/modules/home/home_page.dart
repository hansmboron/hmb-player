import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/modules/home/widgets/playlist_tile.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    int _orientation = MediaQuery.of(context).orientation.index;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('HMB Player'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: controller.handleClick,
            itemBuilder: (BuildContext context) {
              return {'Configurações', 'Sair'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: context.themeOrange,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: _size.width * 0.04,
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('playlists').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(context.themeOrange),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar produtos!',
                    style: TextStyle(color: Colors.red, fontSize: 30)),
              );
            } else if (snapshot.data!.size <= 0) {
              return const Center(
                child: Text('Erro ao carregar produtos!',
                    style: TextStyle(color: Colors.red, fontSize: 30)),
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
    );
  }
}
