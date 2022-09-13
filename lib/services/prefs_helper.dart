import 'package:hive/hive.dart';

import 'weather_api_client.dart';
import '../model/weather_data.dart';

class PrefsHelper {
  static const String keyCities = "cities";

  static const String keyTheme = "theme";

  static const String keyFirstInstall = "firstInstall";

  static const String keyApiKey = "apiKey";

  static const String keyUnitS = "unitS";

  static const String prefsBoxName = "prefs";
  static Box prefsBox = Hive.box(prefsBoxName);

  static List<String> cities = [];
  static List weatherDataList = [];
  static String theme = "";
  static String apiKey = "";
  static String unitS = "";
  static bool isRunning = false;
  static bool reload = true;
  static bool isShown = false;

  PrefsHelper() {
    getData();
  }

  void getData() async {
    apiKey = getValue(keyApiKey) ?? "";
    theme = getValue(keyTheme) ?? "system";
    cities = getValue(keyCities) ?? [];
    unitS = getValue(unitS) ?? "metric";
    for (var element in cities) {
      getWeatherData(element, apiKey, unitS);
    }
  }

  static void updateValue(String key, dynamic value) {
    prefsBox.put(key, value);
  }

  static dynamic getValue(String key) {
    return prefsBox.get(key);
  }

  static Future<dynamic> getWeatherData(
      String city, String apiKey, String unitS) async {
    WeatherData weatherData = WeatherData();
    WeatherApiClient client = WeatherApiClient();
    weatherData = await client.getWeatherData(city, apiKey, unitS);
    // Cod 404 is returned for wrong location name.
    // Cod 401 is returned for wrong api key.
    if (weatherData.cod == "404") {
      return weatherData.cod;
    } else if (weatherData.cod == 401) {
      return weatherData.cod;
    } else {
      for (var element in weatherDataList) {
        if (element.name == weatherData.name) {
          weatherDataList.remove(element);
          weatherDataList.add(weatherData);
          return weatherData.cod;
        }
      }
      weatherDataList.add(weatherData);
    }
    return weatherData.cod;
  }
}
