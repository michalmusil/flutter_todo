import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFFE8C7C),
  onPrimary: Color(0xFF191919),
  secondary: Color(0xFF3A82EE),
  onSecondary: Color(0xFFF5F5F5),
  background: Color(0xFFF5F5F5),
  onBackground: Color(0xFF191919),
  surface: Color(0xFFE8E8E8),
  onSurface: Color(0xFF191919),
  error: Color(0xDAE10000),
  onError: Color(0xFFF1F1F1),
  shadow: Color(0xFF545454)
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFE8C7C),
  onPrimary: Color(0xFF191919),
  secondary: Color(0xFF3A82EE),
  onSecondary: Color(0xFFF5F5F5),
  background: Color(0xFF191919),
  onBackground: Color(0xFFD4D4D4),
  surface: Color.fromARGB(255, 38, 38, 38),
  onSurface: Color.fromARGB(255, 212, 212, 212),
  error: Color(0xFFB20000),
  onError: Color(0xFFDCDCDC),
  shadow: Color.fromARGB(255, 79, 79, 79)
);


const appTextColor = Color(0xFFD4D4D4);

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