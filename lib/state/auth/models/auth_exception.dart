import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthException {
  String get message => "Something went wrong";

  String getLocalizedMessage(BuildContext context){
    return AppLocalizations.of(context)!.somethingWentWrong;
  }
}

class UserNotFoundException implements AuthException {
  @override
  String get message => "No user found with provided credentials";
  
  @override
  String getLocalizedMessage(BuildContext context) {
    return AppLocalizations.of(context)!.userNotFound;
  }

}
class InvalidCredentialsException implements AuthException {
  @override
  String get message => "Invalid credentials";
  
  @override
  String getLocalizedMessage(BuildContext context) {
    return AppLocalizations.of(context)!.invalidCredentials;
  }
}

class EmailAlreadyInUseException implements AuthException {
  @override
  String get message => "E-mail already taken";
  
  @override
  String getLocalizedMessage(BuildContext context) {
    return AppLocalizations.of(context)!.emailTaken;
  }
}

class WeakPasswordException implements AuthException {
  @override
  String get message => "Password too weak";
  
  @override
  String getLocalizedMessage(BuildContext context) {
    return AppLocalizations.of(context)!.weakPassword;
  }
}