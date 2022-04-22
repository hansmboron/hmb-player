import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hmbplayer/modules/playlist/playlist_controller.dart';

import '../../../models/audio_model.dart';

class PlaylistTile extends StatelessWidget {
  PlaylistTile({
    Key? key,
    required this.audio,
  }) : super(key: key);

  final PlaylistController controller = Get.find();
  final AudioModel audio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          style: ListTileStyle.drawer,
          tileColor: controller.currentAudio.value.id == audio.id
              ? Colors.lightGreenAccent.withAlpha(130)
              : Colors.white24,
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
        ),
        const Divider(height: 0),
      ],
    );
  }
}
