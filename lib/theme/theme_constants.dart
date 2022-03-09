import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorSchemeSeed: Colors.amber,
  useMaterial3: true,
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
    filled: true,
    fillColor: ColorScheme.fromSeed(seedColor: Colors.amber)
        .primaryContainer
        .withOpacity(0.3),
  ),
);
ThemeData darkTheme = ThemeData(
  colorSchemeSeed: Colors.amber,
  useMaterial3: true,
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
    filled: true,
    fillColor: ColorScheme.fromSeed(seedColor: Colors.amber)
        .primaryContainer
        .withOpacity(0.05),
  ),
);
