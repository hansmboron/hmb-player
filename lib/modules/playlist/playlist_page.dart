import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/modules/playlist/widgets/box_player_widget.dart';
import './playlist_controller.dart';
import 'widgets/audio_title_widget.dart';
import 'widgets/playlist_tile_widget.dart';

class PlaylistPage extends GetView<PlaylistController> {
  PlaylistPage({Key? key}) : super(key: key);
  final DocumentSnapshot snapshot = Get.arguments;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: context.themeOrange,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Hero(
                  tag: snapshot.id,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: _size.height * 0.4,
                    child: CachedNetworkImage(
                      imageUrl: snapshot.get('icon'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        snapshot.get(
                          'title',
                        ),
                        style: TextStyle(
                          color: context.themeOrange,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                AudioTitle(),
                Positioned(
                  bottom: 6,
                  child: Obx(
                    () => Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      width: _size.width * .95,
                      height: 100,
                      child: controller.audioList.isNotEmpty
                          ? BoxPlayer()
                          : const Center(
                              child: Text(
                                'Selecione para ouvir',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Playlist ${snapshot.get('title')}:",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: _size.height * 0.7,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('playlists/${snapshot.id}/audios')
                    .orderBy('title')
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar audios!',
                          style: TextStyle(color: Colors.red, fontSize: 30)),
                    );
                  } else if (snapshot.data!.size <= 0) {
                    return const Center(
                      child: Text('Erro ao carregar audios!',
                          style: TextStyle(color: Colors.red, fontSize: 30)),
                    );
                  } else {
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      children: snapshot.data!.docs.map((d) {
                        AudioModel audio = AudioModel.fromDocument(d);
                        return PlaylistTile(audio: audio);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
