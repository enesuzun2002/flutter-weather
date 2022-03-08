import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/weather/weather_data.dart';

class WeatherApiClient {
  Future<WeatherData> getWeatherData(String location, apiKey, unitS) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=$unitS');

    final response = await http.get(url);
    final responseJson = jsonDecode(response.body);
    WeatherData weatherData = WeatherData.fromJson(responseJson);
    return weatherData;
  }
}
