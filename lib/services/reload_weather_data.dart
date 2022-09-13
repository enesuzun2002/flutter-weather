import 'package:flutter/cupertino.dart';
import 'package:weather/services/weather_prefs_helper.dart';

class ReloadWeatherData extends ChangeNotifier {
  String apiKey = "";

  void weatherDataReload() {
    for (var element in PrefsHelper.cities) {
      if (PrefsHelper.apiKey != "") {
        PrefsHelper.getWeatherData(
            element, PrefsHelper.apiKey, PrefsHelper.unitS);
      }
    }
    notifyListeners();
  }
}
