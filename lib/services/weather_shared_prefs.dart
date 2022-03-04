import 'package:shared_preferences/shared_preferences.dart';

class WeatherSharedPrefs {
  final Future<SharedPreferences> _weatherSharedPrefs =
      SharedPreferences.getInstance();
  final String _keyCities = "cities";

  final String _keyTheme = "theme";

  void updateCities(List<String> cities) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setStringList(_keyCities, cities);
  }

  Future<List<String>> getCities() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getStringList(_keyCities) ?? <String>[];
  }

  void clearSharedPrefs() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.remove(_keyCities);
  }

  void updateTheme(String theme) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setString(_keyTheme, theme);
  }

  Future<String> getTheme() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getString(_keyTheme) ?? "";
  }
}
