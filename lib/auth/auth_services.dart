import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<AuthServices> authService = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  // Stream<User?> get userChanges => firebaseAuth.userChanges();
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    if (currentUser != null) {
      await currentUser!.updateDisplayName(username);
    }
  }

  Future<void> deleteAccount({required String email, required password}) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await firebaseAuth.signInWithCredential(credential);
    await firebaseAuth.currentUser?.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    if (currentUser != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );
      await firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      await firebaseAuth.currentUser!.updatePassword(newPassword);
    }
  }
}
