import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/models/audio_model.dart';
import 'package:hmbplayer/models/playlist_model.dart';
import 'package:hmbplayer/repositories/home/home_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetStorage box = GetStorage();
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

  @override
  Future<void> removeAudio(
      {required AudioModel audioModel,
      required String userUid,
      required Function onFail,
      required Function onSuccess}) {
    // TODO: implement removeAudio
    throw UnimplementedError();
  }

  @override
  Future<void> addToMyPlaylist(
      {required AudioModel audio,
      required Function onFail,
      required Function onSuccess}) async {
    try {
      UserModel user = UserModel.fromMap(box.read('user'));
      await firestore
          .collection('users/${user.uid}/my_playlist')
          .doc(audio.id)
          .set(audio.toMap())
          .then(
            (value) => onSuccess(),
          );
    } catch (e) {
      onFail();
      log("Falha ao adicionar audio na minha playlist ${e.toString()}");
    }
  }
}
