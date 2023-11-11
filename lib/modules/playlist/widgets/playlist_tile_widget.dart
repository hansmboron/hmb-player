import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/ui/theme_extensions.dart';
import '../playlist_controller.dart';

import '../../../models/audio_model.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistController controller = Get.find();
  final AudioModel audio;
  final String playlistName;
  final bool isLocal;
  final bool isUserPlay;

  PlaylistTile({
    super.key,
    required this.audio,
    required this.playlistName,
    required this.isLocal,
    required this.isUserPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.3),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 1.5,
            color: Colors.black.withOpacity(.7),
          ),
        ),
        child: ListTile(
          style: ListTileStyle.drawer,
          iconColor: controller.currentAudio.value.id == audio.id ? context.themeGreen : Colors.white60,
          onTap: () {
            controller.setSelected(audio);
          },
          dense: false,
          leading: Icon(controller.currentAudio.value.id == audio.id ? Icons.play_arrow_outlined : Icons.play_arrow_rounded),
          title: Text(
            '${audio.title} (${audio.author})',
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // shadows: controller.currentAudio.value.id == audio.id
              //     ? [const Shadow(color: Colors.white, blurRadius: 1)]
              //     : [],
              color: controller.currentAudio.value.id == audio.id ? context.themeGreen : Colors.white60,
            ),
          ),
          trailing: isLocal
              ? const SizedBox()
              : SizedBox(
                  height: 50,
                  width: controller.isAdmin() ? 96 : 50,
                  child: Center(
                    child: Row(
                      children: [
                        controller.isAdmin()
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Remover?',
                                    content: Text('Remover audio ${audio.title}?'),
                                    textConfirm: 'Confirmar',
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      Get.back();
                                      if (controller.isAdmin()) {
                                        controller.removeAudio(audio: audio, playlistName: playlistName);
                                      }
                                    },
                                  );
                                },
                              )
                            : const SizedBox(),
                        IconButton(
                          tooltip: isUserPlay ? 'Remover ${audio.title} da minha playlist!' : 'Adicionar ${audio.title} à minha playlist!',
                          splashColor: Colors.green,
                          highlightColor: Colors.green,
                          onPressed: () {
                            Get.defaultDialog(
                              title: isUserPlay ? 'Remover?' : 'Adicionar?',
                              content: Text(isUserPlay ? 'Remover o audio ${audio.title} da minha playlist?' : 'Adicionar o audio ${audio.title} na minha playlist?'),
                              textConfirm: 'Confirmar',
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                Get.back();
                                if (isUserPlay) {
                                  controller.removeFromMyPlaylist(audio: audio);
                                } else {
                                  controller.addToMyPlaylist(audio: audio);
                                }
                              },
                            );
                          },
                          icon: Icon(isUserPlay ? Icons.playlist_remove_rounded : Icons.playlist_add_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
