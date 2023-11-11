import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../playlist_controller.dart';

class AudioSubtitle extends StatelessWidget {
  final PlaylistController controller = Get.find();
  AudioSubtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 105,
        left: 10,
        width: MediaQuery.of(context).size.width * .95,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                controller.currentAudio.value.id != null ? controller.currentAudio.value.author ?? '' : ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black,
                ),
                maxLines: 1,
              ),
            ),
            Center(
              child: Text(
                controller.currentAudio.value.id != null ? controller.currentAudio.value.author ?? '' : ' ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
