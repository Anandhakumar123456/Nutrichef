// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_signUpRequested);
    on<LoginRequested>(_loginRequested);
    on<LogoutRequested>(_logout);
  }

  Future<void> _loginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final uid = userCredential.user!.uid;
      emit(Authenticated(userId: uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(error: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(error: "Login Failed ${e.toString()}"));
    }
  }

  Future<void> _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _auth.signOut();
      emit(UnAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(error: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(error: "Logout Failed ${e.toString()}"));
    }
  }

  Future<void> _signUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
      final uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'email': event.email,
        'username': event.username,
        'profileImageUrl': '',
        'joinedAt': Timestamp.now(),
      });
      emit(Authenticated(userId: uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(error: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(error: "Something went wrong while signing up."));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
