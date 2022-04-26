import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/modules/playlist/playlist_controller.dart';

import '../../../models/audio_model.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistController controller = Get.find();
  final AudioModel audio;
  final bool isLocal;
  final bool isUserPlay;

  PlaylistTile({
    Key? key,
    required this.audio,
    required this.isLocal,
    required this.isUserPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ListTile(
            style: ListTileStyle.drawer,
            tileColor: controller.currentAudio.value.id == audio.id
                ? Colors.lightGreenAccent.withAlpha(100)
                : Colors.transparent,
            iconColor: Colors.black,
            onTap: () {
              controller.setSelected(audio);
            },
            dense: false,
            leading: Icon(controller.currentAudio.value.id == audio.id
                ? Icons.play_arrow_outlined
                : Icons.play_arrow_rounded),
            title: Text(
              "${audio.title} (${audio.author})",
            ),
            trailing: isLocal
                ? const SizedBox()
                : SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: IconButton(
                        tooltip: isUserPlay
                            ? "Remover ${audio.title} da minha playlist!"
                            : "Adicionar ${audio.title} à minha playlist!",
                        color: Colors.black,
                        splashColor: Colors.green,
                        highlightColor: Colors.green,
                        onPressed: () {
                          Get.defaultDialog(
                            title: isUserPlay ? "Remover?" : "Adicionar?",
                            content: Text(isUserPlay
                                ? 'Remover o audio ${audio.title} da minha playlist?'
                                : 'Adicionar o audio ${audio.title} na minha playlist?'),
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
                        icon: Icon(isUserPlay
                            ? Icons.playlist_remove_rounded
                            : Icons.playlist_add_rounded),
                      ),
                    ),
                  ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
