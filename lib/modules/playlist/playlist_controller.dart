import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/core/mixins/mesages_mixin.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/services/home/home_service.dart';

import '../../models/user_model.dart';

class PlaylistController extends GetxController with MessagesMixin {
  final HomeService _homeService;
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final GetStorage storage = GetStorage();
  final loading = false.obs;
  final isMuted = false.obs;
  final isFaster = false.obs;
  final isSlower = false.obs;
  final isRepeat = false.obs;
  final isShuffle = false.obs;
  final message = Rxn<MessageModel>();
  Rx<AudioModel> currentAudio = AudioModel().obs;
  RxList<AudioModel> localAudios = RxList();
  RxList<AudioModel> remoteAudios = RxList();
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = const Duration(seconds: 1).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  String audioPath = "";
  late AudioPlayer audioPlayer;

  PlaylistController({required HomeService homeService})
      : _homeService = homeService;

  @override
  void onInit() {
    messageListener(message);
    audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    audioPlayer.onAudioPositionChanged.listen((p) {
      position.value = p;
    });

    audioPlayer.onPlayerError.listen((event) {
      message(
        MessageModel(
          title: 'Erro!',
          message: 'Erro ao reproduzir audio!',
          type: MessageType.error,
        ),
      );
    });

    audioPlayer.onPlayerCompletion.listen((event) async {
      duration.value = const Duration(seconds: 1);
      position.value = const Duration(seconds: 0);
      if (isRepeat.value) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
        isRepeat.value = false;
      }

      // auto play next song
      await playNext();
    });
    super.onInit();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  bool isAdmin() {
    dynamic admins = jsonDecode(remoteConfig.getValue('admins').asString());
    UserModel user = UserModel.fromMap(storage.read('user'));
    String remoteUid = admins['admins'][0];
    String userUid = user.uid ?? '0';
    return remoteUid == userUid;
  }

  Future<QuerySnapshot<Object?>> getRemoteAudios(String snapshotId) async {
    QuerySnapshot<Object?> audios = await _homeService.remoteAudios(snapshotId);
    remoteAudios.value = audios.docs.map((d) {
      return AudioModel.fromDocument(d);
    }).toList();

    return _homeService.remoteAudios(snapshotId);
  }

  Future<QuerySnapshot<Object?>> getUserPlaylist() async {
    QuerySnapshot<Object?> audios = await _homeService.getUserPlaylist();
    remoteAudios.value = audios.docs.map((d) {
      return AudioModel.fromDocument(d);
    }).toList();

    return _homeService.getUserPlaylist();
  }

  Future<void> removeFromMyPlaylist({required AudioModel audio}) async {
    await _homeService
        .removeFromMyPlaylist(
      audio: audio,
      onFail: () {
        message(
          MessageModel(
            title: 'Erro!',
            message: 'Erro ao remover ${audio.title} da minha playlist!',
            type: MessageType.error,
          ),
        );
      },
      onSuccess: () {
        message(
          MessageModel(
            title: 'Sucesso!',
            message: '${audio.title} REMOVIDO da minha playlist!',
            type: MessageType.info,
          ),
        );
      },
    )
        .then(
      (value) {
        remoteAudios.removeWhere((a) => a.id == audio.id);
        update();
      },
    );
  }

  Future<void> removeAudio(
      {required AudioModel audio, required String playlistName}) async {
    await _homeService
        .removeAudio(
      audio: audio,
      playlistName: playlistName,
      onFail: () {
        message(
          MessageModel(
            title: 'Erro!',
            message: 'Erro ao remover ${audio.title} do banco!',
            type: MessageType.error,
          ),
        );
      },
      onSuccess: () {
        message(
          MessageModel(
            title: 'Sucesso!',
            message: '${audio.title} REMOVIDO do banco!',
            type: MessageType.info,
          ),
        );
      },
    )
        .then((value) {
      remoteAudios.removeWhere((a) => a.id == audio.id);
      update();
    });
  }

  Future<void> addToMyPlaylist({required AudioModel audio}) async {
    await _homeService.addToMyPlaylist(
      audio: audio,
      onFail: () {
        message(
          MessageModel(
            title: 'Erro!',
            message: 'Erro ao adicionar ${audio.title} à minha playlist!',
            type: MessageType.error,
          ),
        );
      },
      onSuccess: () {
        message(
          MessageModel(
            title: 'Sucesso!',
            message: '${audio.title} ADICIONADO à minha playlist!',
            type: MessageType.info,
          ),
        );
      },
    );
  }

  Future<void> onPlayBtn({required bool isLocal}) async {
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
    } else {
      try {
        audioPlayer.setUrl(audioPath);

        int result = await audioPlayer.play(audioPath,
            isLocal: isLocal, stayAwake: true);
        if (result == 1) {
          isPlaying.value = true;
          if (isFaster.value) {
            await audioPlayer.setPlaybackRate(1.5);
            isSlower.value = false;
          }
          if (isSlower.value) {
            await audioPlayer.setPlaybackRate(0.5);
            isFaster.value = false;
          }
        } else {
          isPlaying.value = false;
          message(
            MessageModel(
              title: 'Erro!',
              message: 'Falha ao reproduzir audio',
              type: MessageType.error,
            ),
          );
        }
      } on RangeError catch (e) {
        message(
          MessageModel(
            title: 'Erro!',
            message: 'Falha ao reproduzir audio',
            type: MessageType.error,
          ),
        );
        log(e.toString());
      }
    }
  }

  Future<void> playNext() async {
    if (localAudios.isNotEmpty && localAudios.length > 1 && !isRepeat.value) {
      AudioModel audio =
          localAudios.firstWhere((a) => a.id == currentAudio.value.id);
      var pos = localAudios.indexOf(audio);

      if (isShuffle.value) {
        await setSelected(localAudios[Random().nextInt(localAudios.length)])
            .then(
          (value) async => await onPlayBtn(isLocal: true),
        );
      } else {
        await setSelected(localAudios.length > pos + 1
                ? localAudios[pos + 1]
                : localAudios[0])
            .then(
          (value) async => await onPlayBtn(isLocal: true),
        );
      }
    }

    if (remoteAudios.isNotEmpty && remoteAudios.length > 1 && !isRepeat.value) {
      int pos = 0;
      try {
        AudioModel audio =
            remoteAudios.firstWhere((a) => a.id == currentAudio.value.id);
        pos = remoteAudios.indexOf(audio);
      } catch (e) {
        log(e.toString());
      }

      if (isShuffle.value) {
        await setSelected(remoteAudios[Random().nextInt(remoteAudios.length)])
            .then(
          (value) async => await onPlayBtn(isLocal: false),
        );
      } else {
        await setSelected(remoteAudios.length > pos + 1
                ? remoteAudios[pos + 1]
                : remoteAudios[0])
            .then(
          (value) async => await onPlayBtn(isLocal: false),
        );
      }
    }
  }

  Future<void> setSelected(AudioModel audio) async {
    await audioPlayer.stop();
    isPlaying.value = false;

    position.value = const Duration(seconds: 0);
    duration.value = const Duration(seconds: 1);
    audioPath = audio.audio ?? "";
    currentAudio.value = audio;
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
      dialogTitle: "Selecione audios",
    );

    if (result != null) {
      for (var item in result.files) {
        localAudios.add(AudioModel(
          id: item.identifier,
          audio: item.path,
          author: 'local',
          title: item.name,
        ));
      }
      update();
    } else {
      message(
        MessageModel(
          title: 'Erro!',
          message: 'Nenhum arquivo selecionado!',
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> changeDuration(double value) async {
    Duration newDuration = Duration(seconds: value.toInt());
    await audioPlayer.seek(newDuration);
  }

  Future<void> toggleMute() async {
    if (isMuted.value) {
      await audioPlayer.setVolume(1);
      isMuted.value = false;
    } else {
      await audioPlayer.setVolume(0);
      isMuted.value = true;
      message(
        MessageModel(
          title: 'Mudo!',
          message: 'O som foi mutado!',
          type: MessageType.error,
        ),
      );
    }
  }

  void toggleShuffle() {
    if (isShuffle.value) {
      isShuffle.value = false;
    } else {
      isShuffle.value = true;
      message(
        MessageModel(
          title: 'Modo Aleatório Ativado!',
          message: 'Modo Aleatório Ativado!',
          type: MessageType.info,
        ),
      );
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
      message(
        MessageModel(
          title: 'Repetir Ativado!',
          message: 'Repetir o mesmo audio Ativado!',
          type: MessageType.info,
        ),
      );
    }
  }
}
