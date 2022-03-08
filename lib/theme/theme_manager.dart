import 'package:flutter/material.dart';
import 'package:weather/services/weather_shared_prefs.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String theme = '';
  get themeMode => _themeMode;

  void getUserTheme() async {
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    theme = await wsf.getTheme();
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
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
