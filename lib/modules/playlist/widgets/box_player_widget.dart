import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/ui/theme_extensions.dart';
import '../playlist_controller.dart';

class BoxPlayer extends StatelessWidget {
  final PlaylistController controller = Get.find();
  final bool isLocal;

  BoxPlayer({super.key, required this.isLocal});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () => GestureDetector(
                onTap: controller.toggleRepeat,
                child: Icon(
                  controller.isRepeat.value ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                  color: controller.isRepeat.value ? context.themeGreen : context.themeOrange,
                  size: 30,
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.toggleShuffle,
                child: Icon(
                  controller.isShuffle.value ? Icons.shuffle_rounded : Icons.arrow_right_alt_rounded,
                  color: context.themeOrange,
                  size: 30,
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.slower,
                child: Icon(
                  Icons.fast_rewind_rounded,
                  color: controller.isSlower.value ? context.themeGreen : context.themeOrange,
                  size: 30,
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: () {
                  controller.onPlayBtn(isLocal: isLocal);
                },
                child: Icon(
                  controller.isPlaying.value ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  color: context.themeOrange,
                  size: 50,
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.faster,
                child: Icon(
                  Icons.fast_forward_rounded,
                  color: controller.isFaster.value ? context.themeGreen : context.themeOrange,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.playNext,
              child: Icon(
                Icons.skip_next_rounded,
                color: context.themeOrange,
                size: 30,
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.toggleMute,
                child: Icon(
                  controller.isMuted.value ? Icons.volume_mute_rounded : Icons.volume_up_rounded,
                  color: context.themeOrange,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Obx(
                () => Text(
                  controller.position.toString().split('.')[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              height: 25,
              width: size.width * .6,
              child: Obx(
                () => (controller.isPlaying.value && !isLocal && controller.position.value < const Duration(milliseconds: 1))
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )
                    : Slider(
                        value: controller.position.value.inSeconds.toDouble(),
                        min: 0.0,
                        max: controller.duration.value.inSeconds.ceilToDouble(),
                        onChanged: controller.changeDuration,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Obx(
                () => Text(
                  controller.duration.toString().split('.')[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
