import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/models/playlist_model.dart';
import 'package:hmbplayer/services/home/home_service.dart';

import '../../repositories/home/home_repository.dart';

class HomeServiceImpl implements HomeService {
  final HomeRepository _homeRepository;

  HomeServiceImpl({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId) =>
      _homeRepository.remoteAudios(snapshotId);

  @override
  Future<List<PlaylistModel?>> getPlaylists() => _homeRepository.getPlaylists();

  @override
  Future<void> addAudio({
    required AudioModel audioModel,
    required File file,
    required String playlistName,
    required Function onFail,
    required Function onSuccess,
  }) =>
      _homeRepository.addAudio(
        audioModel: audioModel,
        file: file,
        playlistName: playlistName,
        onFail: onFail,
        onSuccess: onSuccess,
      );

  @override
  Future<void> addToMyPlaylist({
    required AudioModel audio,
    required Function onFail,
    required Function onSuccess,
  }) =>
      _homeRepository.addToMyPlaylist(
        audio: audio,
        onFail: onFail,
        onSuccess: onSuccess,
      );
}
