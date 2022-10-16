import 'package:get/get.dart';
import 'package:weather/services/prefs_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/weather_data.dart';
import '../widgets/helper_widgets.dart';

class WeatherController extends GetxController {
  // Widget IDs
  static String weatherListViewId = "weatherListViewId";
  static String unitDialogId = "unitDialogId";

  WeatherController() {
    for (var element in PrefsHelper.cities) {
      getWeatherData(element, PrefsHelper.apiKey, PrefsHelper.unitS);
    }
  }

  void weatherDataReload() {
    for (var element in PrefsHelper.cities) {
      if (PrefsHelper.apiKey != "") {
        getWeatherData(element, PrefsHelper.apiKey, PrefsHelper.unitS);
      }
    }
    update([weatherListViewId]);
  }

  void removeCity(WeatherData weatherData) {
    HelperWidgets hw = HelperWidgets();
    PrefsHelper.weatherDataList.remove(weatherData);
    PrefsHelper.updateValue(PrefsHelper.keyCities,
        hw.weatherListCityNamesToList(PrefsHelper.weatherDataList));
    update([weatherListViewId]);
  }

  Future<WeatherData> getWeatherDataFromAPI(
      String location, apiKey, unitS) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=$unitS');

    final response = await http.get(url);
    final responseJson = jsonDecode(response.body);
    WeatherData weatherData = WeatherData.fromJson(responseJson);
    return weatherData;
  }

  Future<dynamic> getWeatherData(
      String city, String apiKey, String unitS) async {
    WeatherData weatherData = WeatherData();

    weatherData = await getWeatherDataFromAPI(city, apiKey, unitS);
    // Cod 404 is returned for wrong location name.
    // Cod 401 is returned for wrong api key.
    if (weatherData.cod == "404") {
      return weatherData.cod;
    } else if (weatherData.cod == 401) {
      return weatherData.cod;
    } else {
      for (var element in PrefsHelper.weatherDataList) {
        if (element.name == weatherData.name) {
          PrefsHelper.weatherDataList.remove(element);
          PrefsHelper.weatherDataList.add(weatherData);
          return weatherData.cod;
        }
      }
      PrefsHelper.weatherDataList.add(weatherData);
    }
    return weatherData.cod;
  }

  void updateUnit(String unit) {
    PrefsHelper.updateValue(PrefsHelper.keyUnitS, unit);
    PrefsHelper.unitS = unit;
    update([unitDialogId]);
  }
}
