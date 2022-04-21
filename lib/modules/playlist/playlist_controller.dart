import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/models/audio_model.dart';

class PlaylistController extends GetxController {
  RxList<AudioModel> audioList = RxList();
  RxBool isPlaying = false.obs;
  Duration? duration;
  Duration? position;
  String audioPath =
      "https://traffic.libsyn.com/podcastsinenglish/fruitnveg.mp3";
  late AudioPlayer audioPlayer;

  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
    audioPlayer.onAudioPositionChanged.listen((p) {
      position = p;
    });
    super.onInit();
  }

  Future<void> onPlayBtn() async {
    audioPlayer.setUrl(audioPath);
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
    } else {
      int result = await audioPlayer.play(audioPath);
      isPlaying.toggle();
      if (result == 1) {
        log("Tocando");
      } else {
        log("Falha ao carregar");
      }
      isPlaying.value = true;
    }
  }

  void setSelected(AudioModel audio) {
    audioPath = audio.audio ?? "";
    audioList.clear();
    audioList.add(audio);
  }
}
