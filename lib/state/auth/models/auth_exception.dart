abstract class AuthExceptionBase implements Exception {
  abstract final String message;
}

class AuthException implements AuthExceptionBase {
  @override
  String get message => "Something went wrong";
  
}

class UserNotFoundException implements AuthException {
  @override
  String get message => "No user found with provided credentials";
}

class InvalidCredentialsException implements AuthException {
  @override
  String get message => "Invalid credentials";
}

class EmailAlreadyInUseException implements AuthException {
  @override
  String get message => "E-mail already taken";
}

class WeakPasswordException implements AuthException {
  @override
  String get message => "Password too weak";
}