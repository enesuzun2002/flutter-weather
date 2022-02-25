import 'package:weather/main.dart';
import 'package:weather/widgets/get_weather.dart';

class ReloadWeatherData {
  static Future<void> weatherDataReload() async {
    for (var element in MyApp.weatherList) {
      await GetWeather.getData(element.name);
    }
  }
}
