import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/weather/weather_data.dart';

class WeatherApiClient {
  static WeatherApiClient _weatherApiClient = WeatherApiClient._internal();
  WeatherApiClient._internal();

  factory WeatherApiClient() {
    return _weatherApiClient;
  }

  Future<WeatherData> getWeatherData(String location) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=fe884b9ccd49d8b0101b65a86b0225c6&units=metric');

    final response = await http.get(url);
    final responseJson = jsonDecode(response.body);
    WeatherData weatherData = WeatherData.fromJson(responseJson);
    return weatherData;
  }
}
