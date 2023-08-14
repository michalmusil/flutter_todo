import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/model/user/auth_user.dart';
import 'package:todo_list/services/auth/iauth_service.dart';

import 'auth_exception.dart';

class AuthServiceImpl implements IAuthService {
  @override
  AuthUser? get user {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser != null ? AuthUser.fromFirebaseUser(firebaseUser) : null;
  }

  @override
  bool get isLoggedIn => user != null;


  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
    try{
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return AuthUser.fromFirebaseUser(credentials.user!);
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "wrong-password": throw InvalidCredentialsException();
        case "user-not-found": throw UserNotFoundException();
        default: throw AuthException();
      }
    }
  }
  
  @override
  Future<bool> logOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
  
  @override
  Future<AuthUser> register({required String email, required String password}) async {
    try{
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return AuthUser.fromFirebaseUser(credentials.user!);
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "email-already-in-use": throw EmailAlreadyInUseException();
        case "invalid-email": throw InvalidCredentialsException();
        case "weak-password": throw WeakPasswordException();
        default: throw AuthException();
      }
    }
  }
}