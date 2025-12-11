
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class SocialMediaTheme {
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
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light
      ),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        color: Colors.black
      ),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      elevation: 0,
      color: lightBG,
    ),
  );

  static TextStyle appBarActionsTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Colors.blue,
        surface: darkBG, //Colors.black
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
      ),
      backgroundColor: darkBG,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        color: Colors.white
      ),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      elevation: 0,
      color: darkBG,
    ),
  );
}