import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/models/audio_model.dart';
import './playlist_controller.dart';

class PlaylistPage extends GetView<PlaylistController> {
  PlaylistPage({Key? key}) : super(key: key);
  final DocumentSnapshot snapshot = Get.arguments;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(snapshot.get('title')),
      //   backgroundColor: Colors.transparent,
      // ),
      // backgroundColor: Theme.of(context).primaryColor,
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
                Obx(
                  () => Visibility(
                    visible: controller.audioList.isNotEmpty,
                    child: Positioned(
                      bottom: 110,
                      child: Text(
                        controller.audioList.first.title!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  child: Obx(
                    () => Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      width: _size.width * .95,
                      height: 80,
                      child: controller.audioList.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: controller.onPlayBtn,
                                  child: Icon(
                                    controller.isPlaying.value
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    color: context.themeOrange,
                                    size: 50,
                                  ),
                                ),
                              ],
                            )
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
            const Text("Audios:"),
            Container(
              height: _size.height * 0.7,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('playlists/${snapshot.id}/audios')
                    .get(),
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
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                controller.setSelected(audio);
                              },
                              dense: false,
                              leading: const Icon(Icons.play_arrow),
                              title: Text(
                                "${audio.title} (${audio.author})",
                              ),
                            ),
                            const Divider(height: 0),
                          ],
                        );
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
