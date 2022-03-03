import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';

class ReloadWeatherData {
  static Future<void> weatherDataReload() async {
    for (var element in MyApp.weatherList) {
      CustomWidgets cw = CustomWidgets();
      await cw.getData(element.name);
    }
  }

  static Future<void> weatherDataReloadSharedPrefs() async {
    CustomWidgets cw = CustomWidgets();
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    for (var element in await wsf.getCities()) {
      await cw.getData(element);
    }
  }
}
