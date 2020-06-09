import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  static const String THEME = "theme";

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  ThemeData getTheme() => _themeData;

  setTheme(ThemeData theme) async {
    _themeData = theme;

    (await SharedPreferences.getInstance()).setString(
      THEME,
      theme.brightness == Brightness.light ? "light" : "dark",
    );

    notifyListeners();
  }

 /* Future<String> getThemeKey() async {
    return (await SharedPreferences.getInstance()).getString(ThemeKey.THEME);
  }*/
}
