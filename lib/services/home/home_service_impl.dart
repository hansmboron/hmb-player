import 'package:cloud_firestore/cloud_firestore.dart';
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
}
