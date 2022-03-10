import 'package:flutter/cupertino.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/variables.dart';
import 'package:weather/widgets/helper_widgets.dart';

class ReloadWeatherData extends ChangeNotifier {
  String apiKey = "";
  Future<void> weatherDataReload() async {
    for (var element in Variables.weatherList) {
      HelperWidgets cw = HelperWidgets();
      WeatherSharedPrefs wsf = WeatherSharedPrefs();
      if (await wsf.getApiKey() != "") {
        await cw.getData(
            element.name, await wsf.getApiKey(), await wsf.getUnitS());
      }
    }
    notifyListeners();
  }

  Future<void> weatherDataReloadSharedPrefs() async {
    HelperWidgets cw = HelperWidgets();
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    for (var element in await wsf.getCities()) {
      if (await wsf.getApiKey() != "") {
        await cw.getData(element, await wsf.getApiKey(), await wsf.getUnitS());
      }
    }
    notifyListeners();
  }

  Future<void> weatherUnitSReload() async {
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    Variables.unitS = await wsf.getUnitS();
    notifyListeners();
  }
}
