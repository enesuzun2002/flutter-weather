import 'package:flutter/cupertino.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';

class ReloadWeatherData extends ChangeNotifier {
  String apiKey = "";
  String _unitS = "";

  get unitS => _unitS;
  Future<void> weatherDataReload() async {
    for (var element in MyApp.weatherList) {
      CustomWidgets cw = CustomWidgets();
      WeatherSharedPrefs wsf = WeatherSharedPrefs();
      if (await wsf.getApiKey() != "") {
        await cw.getData(
            element.name, await wsf.getApiKey(), await wsf.getUnitS());
      }
    }
    notifyListeners();
  }

  Future<void> weatherDataReloadSharedPrefs() async {
    CustomWidgets cw = CustomWidgets();
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    for (var element in await wsf.getCities()) {
      if (await wsf.getApiKey() != "") {
        await cw.getData(element, await wsf.getApiKey(), await wsf.getUnitS());
      }
    }
    notifyListeners();
  }
}
