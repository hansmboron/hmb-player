import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/mixins/loader_mixin.dart';
import 'package:hmbplayer/core/mixins/mesages_mixin.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/models/playlist_model.dart';
import 'package:hmbplayer/services/home/home_service.dart';

class UploadController extends GetxController with LoaderMixin, MessagesMixin {
  final HomeService _homeService;
  final loading = false.obs;
  final message = Rxn<MessageModel>();
  RxString playSelected = 'Rock'.obs;
  RxList<PlaylistModel?> playlists = RxList();
  RxString audioSelected = ''.obs;

  final nameEC = TextEditingController();
  final authorEC = TextEditingController();
  File? file;
  String fileNameWithExt = "arquivo_de_audio";

  UploadController({
    required HomeService homeService,
  }) : _homeService = homeService;

  @override
  void onInit() async {
    loaderListener(loading);
    messageListener(message);
    playlists.value = await _homeService.getPlaylists();
    super.onInit();
  }

  @override
  void onClose() {
    nameEC.dispose();
    authorEC.dispose();
    super.onClose();
  }

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
      dialogTitle: "Selecione audios",
    );

    if (result != null) {
      file = File(result.files.single.path!);
      String fileName = result.files.first.name.split('.').first;
      fileNameWithExt = result.files.first.name;
      audioSelected.value = fileName;
      nameEC.text = fileName;
      authorEC.text = fileName;
      log(audioSelected.value);
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

  Future<void> addAudio(AudioModel audioModel) async {
    loading.value = true;
    await _homeService.addAudio(
        audioModel: audioModel,
        file: file!,
        playlistName: playSelected.value,
        fileName: fileNameWithExt,
        onFail: () {
          log('fail');
          loading.value = false;
          message(
            MessageModel(
                title: 'Erro',
                message: 'Erro ao enviar arquivo',
                type: MessageType.error),
          );
        },
        onSuccess: () {
          log('success');
          loading.value = false;
          message(
            MessageModel(
                title: 'Sucesso',
                message: '$fileNameWithExt enviado com sucesso',
                type: MessageType.info),
          );
        });

    nameEC.text = '';
    authorEC.text = '';
    audioSelected.value = '';
  }
}
