import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hmbplayer/models/user_model.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  UserModel? _user;

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

      User? fuser = userCredential.user;

      if (fuser != null) {
        UserModel userModel = UserModel(
          uid: fuser.uid,
          email: fuser.email,
          name: fuser.displayName,
          photoUrl: fuser.photoURL,
        );
        final box = GetStorage();
        box.write('user', userModel.toMap());
        log("USUARIO lOGADO: ${userModel.name}");
        log("USUARIO lOGADO: ${userModel.email}");

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uid)
            .set(userModel.toMap());
        _user = userModel;
      }
      return fuser;
    }
    throw Exception('Erro ao realizar login com o Google');
  }

  @override
  Future<QuerySnapshot<Object?>> getUsersAudios(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users/$uid/playlist')
        .get();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}
