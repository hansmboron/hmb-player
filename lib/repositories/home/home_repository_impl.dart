import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/models/playlist_model.dart';
import 'package:hmbplayer/repositories/home/home_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId) {
    return FirebaseFirestore.instance
        .collection('playlists/$snapshotId/audios')
        .orderBy('title')
        .get();
  }

  @override
  Future<List<PlaylistModel?>> getPlaylists() async {
    try {
      var downLinks = await FirebaseFirestore.instance
          .collection('playlists')
          .orderBy('title')
          .get();

      return downLinks.docs.map((doc) {
        PlaylistModel playlist = PlaylistModel.fromDocument(doc);
        return playlist;
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<void> addAudio({
    required AudioModel audioModel,
    required File file,
    required String playlistName,
    required Function onFail,
    required Function onSuccess,
  }) async {
    try {
      final UploadTask task = storage
          .ref(playlistName)
          .child(
            const Uuid().v1(),
          )
          .putFile(file);
      await task.whenComplete(() async =>
          audioModel.audio = await task.snapshot.ref.getDownloadURL());

      await firestore
          .collection('playlists/$playlistName/audios')
          .add(audioModel.toMap());

      log('AUDIO: ${audioModel.audio}');
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }
}
