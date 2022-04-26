import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginService {
  Future<User?> login();

  Future<void> logout();
}
