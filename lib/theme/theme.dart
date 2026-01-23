import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppTheme {
  static Color lightPrimary = Color(0xfff3f4f9);
  static Color darkPrimary = Color(0xff2B2B2B);

  static Color lightBG = Color(0xfff3f4f9);
  static Color darkBG = Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.lightBlue,
      surface: lightBG,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(elevation: 0, color: lightBG),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16.0),
      bodySmall: TextStyle(fontSize: 14.0),
      displaySmall: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(fontSize: 12.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.blue,
      surface: darkBG,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    appBarTheme: AppBarTheme(
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: darkBG,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.white),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(elevation: 0, color: darkBG),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16.0),
      bodySmall: TextStyle(fontSize: 14.0),
      displaySmall: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(fontSize: 12.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}
