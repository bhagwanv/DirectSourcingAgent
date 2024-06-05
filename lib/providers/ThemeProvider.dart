import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    hintColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      buttonColor: kPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    scaffoldBackgroundColor: Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  buttonTheme: ButtonThemeData(
    buttonColor: kPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  hintColor: Colors.grey,
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = light;

  ThemeData get themeData => _themeData;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}