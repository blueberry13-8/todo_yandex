import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class Themes {
  static int colorR = 255, colorG = 59, colorB = 45;

  static void fetchImportantColor() {
    colorR = FirebaseRemoteConfig.instance.getInt('colorR');
    colorG = FirebaseRemoteConfig.instance.getInt('colorG');
    colorB = FirebaseRemoteConfig.instance.getInt('colorB');
  }

  static final lightThemeData = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFf7f6f2),
    primaryColorLight: const Color(0xFFFFFFFF),
    primaryColorDark: const Color.fromRGBO(0, 0, 0, 1),
    backgroundColor: const Color(0xFFf7f6f2),
    shadowColor: const Color.fromRGBO(0, 0, 0, 0.3),
    primaryColor: const Color(0xFFf7f6f2),
    disabledColor: const Color.fromRGBO(0, 0, 0, 0.15),
    textTheme: TextTheme(
      button: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blue,
        fontSize: 14,
        height: 24 / 14,
      ),
      headline5: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        height: 20 / 14,
        color: Color(0x4C000000),
      ),
      subtitle2: const TextStyle(
        color: Colors.blue,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.normal,
      ),
      headline4: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        height: 20 / 14,
        color: Color.fromRGBO(colorR, colorG, colorB, 1),
      ),
      bodyText1: const TextStyle(
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: const TextStyle(
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        color: Color.fromRGBO(0, 0, 0, 0.15),
        decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.normal,
      ),
    ),
    dividerColor: const Color.fromRGBO(0, 0, 0, 0.2),
  );

  static final darkThemeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF161618),
    primaryColorLight: const Color(0xFF252528),
    primaryColorDark: const Color.fromRGBO(255, 255, 255, 1),
    backgroundColor: const Color(0xFF161618),
    shadowColor: const Color.fromRGBO(0, 0, 0, 1),
    primaryColor: const Color(0xFF161618),
    disabledColor: const Color.fromRGBO(255, 255, 255, 0.4),
    textTheme: TextTheme(
      button: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blue,
        fontSize: 14,
        height: 24 / 14,
      ),
      headline5: const TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.4),
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        height: 20 / 14,
        color: Color.fromRGBO(255, 255, 255, 0.4),
      ),
      subtitle2: const TextStyle(
        color: Colors.blue,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.normal,
      ),
      headline4: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        height: 20 / 14,
        color: Color.fromRGBO(colorR, colorG, colorB, 1),
      ),
      bodyText1: const TextStyle(
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: const TextStyle(
        fontSize: 16,
        height: 20 / 16,
        overflow: TextOverflow.ellipsis,
        color: Color.fromRGBO(255, 255, 255, 0.4),
        decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.normal,
      ),
    ),
    dividerColor: const Color.fromRGBO(255, 255, 255, 0.2),
  );
}
