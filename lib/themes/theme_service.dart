import 'package:flutter/material.dart';

import 'i_theme_repository.dart';

class ThemeService {
  ThemeService(IThemeRepository themeRepository)
      : _themeRepository = themeRepository;

  IThemeRepository _themeRepository;

  ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.teal,
    accentColor: Colors.deepPurpleAccent,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.orange,
    accentColor: Colors.amber,
    brightness: Brightness.dark,
  );

  Future<ThemeData> getTheme() async {
    final String themeKey = await _themeRepository.getThemeKey();

    if (themeKey == null) {
      await _themeRepository.setThemeKey(lightTheme.brightness);

      return lightTheme;
    } else {
      return themeKey == "light" ? lightTheme : darkTheme;
    }
  }

  Future<ThemeData> toggleTheme(ThemeData theme) async {
    if (theme == lightTheme) {
      theme = darkTheme;
    } else {
      theme = lightTheme;
    }

    await _themeRepository.setThemeKey(theme.brightness);
    return theme;
  }
}