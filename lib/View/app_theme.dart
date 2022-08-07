import 'package:flutter/material.dart';

class Themes {
  // static final lightThemeData = ThemeData(
  //   scaffoldBackgroundColor: const Color(0x00f7f6f2),
  //   primaryColorLight: const Color(0x00000000),
  //   primaryColorDark: const Color(value),
  //   primaryColor: const Color(0x00f7f6f2),
  //   //secondaryHeaderColor: const
  // );
  // static final darkThemeData = ThemeData(
  // );

  static const largeTitle = TextStyle(
      fontSize: 32,
      height: 38 / 32,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static const title =
      TextStyle(fontSize: 20, height: 32 / 20, color: Colors.black);
  static const button = TextStyle(fontSize: 14, height: 24 / 14);
  static const deleteButton =
      TextStyle(fontSize: 14, height: 24 / 14, color: Colors.red);
  static const body =
      TextStyle(fontSize: 16, height: 20 / 16, overflow: TextOverflow.ellipsis);
  static const subhead = TextStyle(fontSize: 14, height: 20 / 14);
}
