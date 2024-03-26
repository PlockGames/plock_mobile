import 'package:flutter/material.dart';

final ThemeData plockTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(),
  primaryColor: Colors.deepOrange,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepOrange,
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepOrange,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white10,
  ),
);