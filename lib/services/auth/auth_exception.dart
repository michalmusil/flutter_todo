class AuthException implements Exception {}

class UserNotFoundException extends AuthException {}

class InvalidCredentialsException extends AuthException {}

class EmailAlreadyInUseException extends AuthException {}

class WeakPasswordException extends AuthException {}