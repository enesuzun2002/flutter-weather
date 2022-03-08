import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherSharedPrefs extends ChangeNotifier {
  final Future<SharedPreferences> _weatherSharedPrefs =
      SharedPreferences.getInstance();
  final String _keyCities = "cities";

  final String _keyTheme = "theme";

  final String _keyFirstInstall = "firstInstall";

  final String _keyApiKey = "apiKey";

  final String _keyUnitS = "unitS";

  String _unitS = "metric";

  get unitS => _unitS;

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
    prefs.remove(_keyApiKey);
  }

  void updateTheme(String theme) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setString(_keyTheme, theme);
  }

  Future<String> getTheme() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getString(_keyTheme) ?? "";
  }

  void updateFirstInstall(bool firstInstall) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setBool(_keyFirstInstall, firstInstall);
  }

  Future<bool> getFirstInstall() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getBool(_keyFirstInstall) ?? true;
  }

  void updateApiKey(String apiKey) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    prefs.setString(_keyApiKey, apiKey);
  }

  Future<String> getApiKey() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getString(_keyApiKey) ?? "";
  }

  void updateUnitS(String unitS) async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    _unitS = unitS;
    notifyListeners();
    prefs.setString(_keyUnitS, unitS);
  }

  Future<String> getUnitS() async {
    SharedPreferences prefs = await _weatherSharedPrefs;
    return prefs.getString(_keyUnitS) ?? "metric";
  }
}
