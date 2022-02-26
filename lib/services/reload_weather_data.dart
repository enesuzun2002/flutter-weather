import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/get_weather.dart';

class ReloadWeatherData {
  static Future<void> weatherDataReload() async {
    for (var element in MyApp.weatherList) {
      await GetWeather.getData(element.name);
    }
  }

  static void weatherDataReloadSharedPrefs() async {
    for (var element in await WeatherSharedPrefs.getCities()) {
      await GetWeather.getData(element);
    }
  }
}
