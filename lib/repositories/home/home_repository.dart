import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeRepository {
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId);
}
