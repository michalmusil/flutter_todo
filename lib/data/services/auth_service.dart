import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/domain/models/auth/auth_exception.dart';
import 'package:todo_list/domain/models/auth/auth_user.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';

class AuthService implements AuthServiceBase {
  final FirebaseAuth _firebaseAuthInstance;

  @override
  AuthUser? get user {
    final temp = _firebaseAuthInstance.currentUser;
    if(temp != null){
      return AuthUser.fromFirebaseUser(temp);
    }
    return null;
  }

  const AuthService(this._firebaseAuthInstance);

  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
    try{
      final credentials = await _firebaseAuthInstance.signInWithEmailAndPassword(email: email, password: password);
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
    await _firebaseAuthInstance.signOut();
    return true;
  }
  
  @override
  Future<AuthUser> register({required String email, required String password}) async {
    try{
      final credentials = await _firebaseAuthInstance.createUserWithEmailAndPassword(email: email, password: password);
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