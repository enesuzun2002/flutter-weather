import 'package:shared_preferences/shared_preferences.dart';

class WeatherSharedPrefs {
  static final Future<SharedPreferences> _weatherSharedPrefs =
      SharedPreferences.getInstance();
  static const _keyCities = "cities";

  static void updateCities(List<String> cities) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setStringList(_keyCities, cities);
  }

  static Future<List<String>> getCities() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getStringList(_keyCities) ?? <String>[];
  }
}
