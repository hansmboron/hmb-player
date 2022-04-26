import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/login/login_repository.dart';
import 'login_service.dart';

class LoginServiceImpl implements LoginService {
  final LoginRepository _loginRepository;

  LoginServiceImpl({
    required LoginRepository loginRepository,
  }) : _loginRepository = loginRepository;

  @override
  Future<User?> login() => _loginRepository.login();

  @override
  Future<void> logout() => _loginRepository.logout();

  @override
  Future<QuerySnapshot<Object?>> getUsersAudios(String uid) {
    return _loginRepository.getUsersAudios(uid);
  }
}
