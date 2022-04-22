import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/mixins/loader_mixin.dart';
import 'package:hmbplayer/core/mixins/mesages_mixin.dart';
import 'package:hmbplayer/models/audio_model.dart';

class PlaylistController extends GetxController
    with MessagesMixin, LoaderMixin {
  final loading = false.obs;
  final isMuted = false.obs;
  final isFaster = false.obs;
  final isSlower = false.obs;
  final isRepeat = false.obs;
  final message = Rxn<MessageModel>();
  Rx<AudioModel> currentAudio = AudioModel().obs;
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  String audioPath = "";
  late AudioPlayer audioPlayer;

  @override
  void onInit() {
    audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });
    audioPlayer.onAudioPositionChanged.listen((p) {
      position.value = p;
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      position.value = const Duration(seconds: 0);
      if (isRepeat.value) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
        isRepeat.value = false;
      }
    });
    loaderListener(loading);
    messageListener(message);
    super.onInit();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> onPlayBtn() async {
    audioPlayer.setUrl(audioPath);
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
    } else {
      int result = await audioPlayer.play(audioPath);
      isPlaying.value = true;
      if (result == 1) {
        log("Tocando");
      } else {
        log("Falha ao carregar");
        MessageModel(
          title: 'Erro!',
          message: 'Falha ao reproduzir audio',
          type: MessageType.error,
        );
      }
      isPlaying.value = true;
    }
  }

  Future<void> setSelected(AudioModel audio) async {
    await audioPlayer.stop();
    isPlaying.value = false;

    position.value = const Duration(seconds: 0);
    duration.value = const Duration(seconds: 0);
    audioPath = audio.audio ?? "";
    currentAudio.value = audio;
  }

  void changeDuration(double value) {
    Duration newDuration = Duration(seconds: value.toInt());
    audioPlayer.seek(newDuration);
  }

  Future<void> toggleMute() async {
    if (isMuted.value) {
      await audioPlayer.setVolume(1);
      isMuted.value = false;
    } else {
      await audioPlayer.setVolume(0);
      isMuted.value = true;
    }
  }

  Future<void> faster() async {
    if (isFaster.value) {
      await audioPlayer.setPlaybackRate(1);
      isFaster.value = false;
      isSlower.value = false;
    } else {
      await audioPlayer.setPlaybackRate(1.5);
      isFaster.value = true;
      isSlower.value = false;
    }
  }

  Future<void> slower() async {
    if (isSlower.value) {
      await audioPlayer.setPlaybackRate(1);
      isSlower.value = false;
      isFaster.value = false;
    } else {
      await audioPlayer.setPlaybackRate(0.5);
      isSlower.value = true;
      isFaster.value = false;
    }
  }

  Future<void> toggleRepeat() async {
    if (isRepeat.value) {
      await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
      isRepeat.value = false;
    } else {
      await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      isRepeat.value = true;
    }
  }
}
