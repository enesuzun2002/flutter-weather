import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/weather/weather_data.dart';
import 'package:weather/api_key/api_key.dart';

class WeatherApiClient {
  Future<WeatherData> getWeatherData(String location) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=${ApiKey.apiKey}&units=metric');

    final response = await http.get(url);
    final responseJson = jsonDecode(response.body);
    WeatherData weatherData = WeatherData.fromJson(responseJson);
    return weatherData;
  }
}
