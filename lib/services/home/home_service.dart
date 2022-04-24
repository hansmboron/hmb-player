import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeService {
  Future<QuerySnapshot<Object?>> remoteAudios(String snapshotId);
}
