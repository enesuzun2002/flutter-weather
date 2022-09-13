import 'package:flutter/material.dart';
import 'package:weather/services/weather_prefs_helper.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String theme = '';
  get themeMode => _themeMode;

  void getUserTheme() {
    theme = PrefsHelper.theme;
    if (theme == "dark") {
      _themeMode = ThemeMode.dark;
    } else if (theme == "light") {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  toogleTheme(ThemeMode theme) {
    _themeMode = theme;
    notifyListeners();
  }

  bool getSystemThemeMode(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? true
        : false;
  }
}
