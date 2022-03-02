import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';

class ReloadWeatherData {
  static Future<void> weatherDataReload() async {
    for (var element in MyApp.weatherList) {
      await CustomWidgets.getData(element.name);
    }
  }

  static Future<void> weatherDataReloadSharedPrefs() async {
    for (var element in await WeatherSharedPrefs.getCities()) {
      await CustomWidgets.getData(element);
    }
  }
}
