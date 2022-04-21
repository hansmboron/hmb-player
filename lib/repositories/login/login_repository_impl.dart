import 'package:firebase_auth/firebase_auth.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<UserCredential> login() async {
    // final googleUser = await GoogleSignIn().signIn();
    // final googleAuth = await googleUser?.authentication;

    // if (googleAuth != null) {
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );

    //   return FirebaseAuth.instance.signInWithCredential(credential);
    // }
    throw Exception('Erro ao realizar login com o Google');
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // GoogleSignIn().signOut();
  }
}
