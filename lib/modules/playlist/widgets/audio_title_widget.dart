import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/modules/playlist/playlist_controller.dart';

class AudioTitle extends StatelessWidget {
  final PlaylistController controller = Get.find();
  AudioTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 115,
        child: Stack(
          children: <Widget>[
            Text(
              controller.currentAudio.value.id != null
                  ? controller.currentAudio.value.title!
                  : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.black,
              ),
            ),
            Text(
              controller.currentAudio.value.id != null
                  ? controller.currentAudio.value.title!
                  : '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
