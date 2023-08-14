import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String uuid;
  final String email;
  final bool isVerified;

  AuthUser({required this.uuid, required this.email, required this.isVerified});

  factory AuthUser.fromFirebaseUser(User user) {
    final id = user.uid;
    final mail = user.email ?? "";
    final verified = user.emailVerified;
    return AuthUser(uuid: id, email: mail, isVerified: verified);
  }
}
