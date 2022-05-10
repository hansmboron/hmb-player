import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/modules/playlist/playlist_controller.dart';
import 'package:marquee/marquee.dart';

class AudioTitle extends StatelessWidget {
  final PlaylistController controller = Get.find();
  AudioTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 130,
        left: 10,
        width: MediaQuery.of(context).size.width * .95,
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 30,
              width: double.maxFinite,
              child: Marquee(
                text: controller.currentAudio.value.id != null
                    ? controller.currentAudio.value.title ?? ''
                    : 'Nenhum audio selecionado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black,
                ),
                blankSpace: 100.0,
                fadingEdgeEndFraction: 0.3,
                fadingEdgeStartFraction: 0.3,
              ),
            ),
            SizedBox(
              height: 30,
              width: double.maxFinite,
              child: Marquee(
                text: controller.currentAudio.value.id != null
                    ? controller.currentAudio.value.title ?? ''
                    : 'Nenhum audio selecionado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.lightGreenAccent.shade700,
                ),
                blankSpace: 100.0,
                fadingEdgeEndFraction: 0.3,
                fadingEdgeStartFraction: 0.3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
