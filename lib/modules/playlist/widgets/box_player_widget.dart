import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/modules/playlist/playlist_controller.dart';

class BoxPlayer extends StatelessWidget {
  final PlaylistController controller = Get.find();
  final bool isLocal;

  BoxPlayer({Key? key, required this.isLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: controller.toggleRepeat,
                child: Icon(
                  controller.isRepeat.value
                      ? Icons.repeat_one_rounded
                      : Icons.repeat_rounded,
                  color: controller.isRepeat.value
                      ? Colors.greenAccent
                      : context.themeOrange,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: controller.toggleShuffle,
                child: Icon(
                  controller.isShuffle.value
                      ? Icons.shuffle_rounded
                      : Icons.arrow_right_alt_rounded,
                  color: context.themeOrange,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: controller.slower,
                child: Icon(
                  Icons.fast_rewind_rounded,
                  color: controller.isSlower.value
                      ? Colors.greenAccent
                      : context.themeOrange,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.onPlayBtn(isLocal: isLocal);
                },
                child: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  color: context.themeOrange,
                  size: 50,
                ),
              ),
              GestureDetector(
                onTap: controller.faster,
                child: Icon(
                  Icons.fast_forward_rounded,
                  color: controller.isFaster.value
                      ? Colors.greenAccent
                      : context.themeOrange,
                  size: 30,
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
              GestureDetector(
                onTap: controller.toggleMute,
                child: Icon(
                  controller.isMuted.value
                      ? Icons.volume_mute_rounded
                      : Icons.volume_up_rounded,
                  color: context.themeOrange,
                  size: 30,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  controller.position.toString().split('.')[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: Slider(
                    value: controller.position.value.inSeconds.toDouble(),
                    min: 0.0,
                    max: controller.duration.value.inSeconds.ceilToDouble(),
                    onChanged: controller.changeDuration,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  controller.duration.toString().split('.')[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
