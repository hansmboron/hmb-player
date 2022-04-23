import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/models/user_model.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<User?> login() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        final box = GetStorage();
        box.write(
            'user',
            UserModel(
              uid: user.uid,
              email: user.email,
              name: user.displayName,
              photoUrl: user.photoURL,
            ).toMap());
        log("USUARIO lOGADO: ${user.displayName}");
        log("USUARIO lOGADO: ${user.email}");
      }

      return user;
    }
    throw Exception('Erro ao realizar login com o Google');
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}
