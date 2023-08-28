import 'package:flutter/material.dart';

const appColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF566299),
  onPrimary: Color(0xFFD4D4D4),
  secondary: Color(0xFFFCBFB7),
  onSecondary: Color(0xFF191919),
  background: Color(0xFF191919),
  onBackground: Color(0xFFD4D4D4),
  surface: Color.fromARGB(255, 38, 38, 38),
  onSurface: Color.fromARGB(255, 212, 212, 212),
  error: Color.fromARGB(255, 178, 0, 0),
  onError: Color.fromARGB(255, 220, 220, 220),
);


const appTextColor = Color.fromARGB(255, 212, 212, 212);

const appTextTheme = TextTheme(
  bodyLarge: TextStyle(color: appTextColor),
  bodyMedium: TextStyle(color: appTextColor),
  bodySmall: TextStyle(color: appTextColor),
  displayLarge: TextStyle(color: appTextColor),
  displayMedium: TextStyle(color: appTextColor),
  displaySmall: TextStyle(color: appTextColor),
  headlineLarge: TextStyle(color: appTextColor),
  headlineMedium: TextStyle(color: appTextColor),
  headlineSmall: TextStyle(color: appTextColor),
  titleLarge: TextStyle(color: appTextColor),
  titleMedium: TextStyle(color: appTextColor),
  titleSmall: TextStyle(color: appTextColor),
  labelLarge: TextStyle(color: appTextColor),
  labelMedium: TextStyle(color: appTextColor),
  labelSmall: TextStyle(color: appTextColor),
);