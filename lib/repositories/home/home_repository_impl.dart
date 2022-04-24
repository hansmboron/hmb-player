import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmbplayer/repositories/home/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId) {
    return FirebaseFirestore.instance
        .collection('playlists/$snapshotId/audios')
        .orderBy('title')
        .get();
  }
}
