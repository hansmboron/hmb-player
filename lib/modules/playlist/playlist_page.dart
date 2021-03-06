import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/modules/playlist/widgets/box_player_widget.dart';
import 'package:path_provider/path_provider.dart';

import './playlist_controller.dart';
import 'widgets/audio_subtitle_widget.dart';
import 'widgets/audio_title_widget.dart';
import 'widgets/playlist_tile_widget.dart';

class PlaylistPage extends GetView<PlaylistController> {
  final bool isLocal;
  final bool isUserPlay;
  final DocumentSnapshot? snapshot = Get.arguments;

  PlaylistPage({Key? key, this.isLocal = false, this.isUserPlay = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    int _orientation = MediaQuery.of(context).orientation.index;
    String playlistTitle = snapshot?.get('title') ?? '';
    String playlistId = snapshot?.id ?? '';

    return WillPopScope(
      onWillPop: () async {
        // delete local files from cache when close and stop player
        String appDir = (await getTemporaryDirectory()).path;
        Directory(appDir).delete(recursive: true);
        return await controller.audioPlayer.stop().then((value) => true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF222222),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Hero(
                    tag: isLocal || isUserPlay ? 0 : snapshot?.id ?? 0,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: _size.height * (_orientation == 0 ? 0.4 : 0.6),
                      child: isLocal || isUserPlay
                          ? Image.asset(
                              isUserPlay
                                  ? 'assets/images/my_playlist.jpg'
                                  : 'assets/images/bg.jpg',
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: snapshot?.get('icon') ?? '',
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
                          isLocal
                              ? "Arquivos Local"
                              : isUserPlay
                                  ? 'Minha Playlist'
                                  : playlistTitle,
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
                  AudioSubtitle(),
                  Positioned(
                    bottom: 6,
                    child: Obx(
                      () => Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        width: _size.width * .95,
                        height: 90,
                        child: controller.currentAudio.value.id != null
                            ? BoxPlayer(isLocal: isLocal)
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
                  Positioned(
                    left: 10,
                    top: 24,
                    child: IconButton(
                        onPressed: () async {
                          // delete local files from cache when close
                          String appDir = (await getTemporaryDirectory()).path;
                          Directory(appDir).delete(recursive: true);
                          await controller.audioPlayer
                              .stop()
                              .then((value) => Get.back());
                        },
                        color: Colors.white60,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: isLocal,
                child: Obx(
                  () => Text(
                    "Playlist Local (${controller.localAudios.length} audio(s)):",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                replacement: Obx(
                  () => Text(
                    "Playlist (${controller.remoteAudios.length} audio(s)):",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: _size.height * 0.57,
                child: GetBuilder<PlaylistController>(
                  builder: ((controller) {
                    return isLocal
                        ? ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemCount: controller.localAudios.length,
                            itemBuilder: (context, index) {
                              return PlaylistTile(
                                audio: controller.localAudios[index],
                                playlistName: playlistId,
                                isLocal: isLocal,
                                isUserPlay: isUserPlay,
                              );
                            },
                          )
                        : FutureBuilder<QuerySnapshot>(
                            future: isUserPlay
                                ? controller.getUserPlaylist()
                                : controller
                                    .getRemoteAudios(snapshot?.id ?? ''),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                    'Erro ao carregar audios!',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              } else if (snapshot.data!.size <= 0) {
                                return const Center(
                                  child: Text(
                                    'Nenhum audio encontrado!',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              } else {
                                return ListView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  children: snapshot.data!.docs.map((d) {
                                    AudioModel audio =
                                        AudioModel.fromDocument(d);
                                    return PlaylistTile(
                                      audio: audio,
                                      playlistName: playlistId,
                                      isLocal: isLocal,
                                      isUserPlay: isUserPlay,
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          );
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: isLocal
            ? FloatingActionButton(
                onPressed: controller.pickFiles,
                tooltip: "Abrir audios(s)",
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.add,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
