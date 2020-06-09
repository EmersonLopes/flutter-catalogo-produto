import 'package:flutter/material.dart';

abstract class IThemeRepository {
  Future<String> getThemeKey();

  Future<void> setThemeKey(Brightness brightness);
}

class ThemeKey {
  static const String THEME = "theme";
}
