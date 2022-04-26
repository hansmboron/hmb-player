import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginService {
  Future<User?> login();

  Future<void> logout();
}
