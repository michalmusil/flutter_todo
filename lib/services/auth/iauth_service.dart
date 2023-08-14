import 'package:todo_list/model/user/auth_user.dart';

abstract class IAuthService {
  AuthUser? get user;

  bool get isLoggedIn;

  Future<AuthUser> logIn({required String email, required String password});

  Future<AuthUser> register({required String email, required String password});

  Future<bool> logOut();
}