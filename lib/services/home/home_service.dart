import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/audio_model.dart';
import '../../models/playlist_model.dart';

abstract class HomeService {
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId);
  Future<List<PlaylistModel?>> getPlaylists();

  Future<void> addAudio({
    required AudioModel audioModel,
    required File file,
    required String playlistName,
    required Function onFail,
    required Function onSuccess,
  });

  Future<void> addToMyPlaylist({
    required AudioModel audio,
    required Function onFail,
    required Function onSuccess,
  });
}
