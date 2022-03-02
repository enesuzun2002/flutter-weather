import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomWidgets {
  static Color getColor(WeatherData weatherData) {
    switch (weatherData.weather[0].main) {
      case "Clouds":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Thunderstorm":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Drizzle":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Rain":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Snow":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Atmosphere":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Clear":
        return const Color.fromARGB(255, 0, 151, 161);
      default:
        return const Color.fromARGB(255, 153, 65, 6);
    }
  }

  static Icon buildNavIcon(IconData iconData, bool active) {
    return Icon(iconData,
        size: 20.0, color: Color(active ? 0xFF0001FC : 0xFF0A1034));
  }

  static AppBar getAppBar(String header) {
    return AppBar(
        centerTitle: true,
        title: Text(
          header,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ));
  }

  static Future<WeatherData?> getData(String city) async {
    WeatherData weatherData = WeatherData();
    WeatherApiClient client = WeatherApiClient();
    weatherData = await client.getWeatherData(city);
    if (weatherData.cod == "404") {
      return MyApp.weatherList.last;
    } else {
      for (var element in MyApp.weatherList) {
        if (element.name == weatherData.name) {
          MyApp.weatherList.remove(element);
          MyApp.weatherList.add(weatherData);
          return weatherData;
        }
      }
      MyApp.weatherList.add(weatherData);
      return weatherData;
    }
  }

  static SingleChildScrollView getWeatherCard(
      BuildContext context, WeatherData weatherData) {
    return SingleChildScrollView(
      child: Container(
        height: 179.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomWidgets.getColor(weatherData),
            borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: getWeatherCardInfo(context, weatherData),
        ),
      ),
    );
  }

  static Container getProgressIndicatorCard() {
    return Container(
      height: 150.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 153, 65, 6),
          borderRadius: BorderRadius.circular(16.0)),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  static String fixCityName(WeatherData weatherData) {
    String name = "";
    if (weatherData.name.toString().contains("Province")) {
      name = weatherData.name.toString().split(" ").first;
    } else {
      name = weatherData.name.toString();
    }
    return name;
  }

  static String getWeatherDescription(
      BuildContext context, String weatherDesc) {
    switch (weatherDesc) {
      case "Clouds":
        return AppLocalizations.of(context)!.clouds;
      case "Thunderstorm":
        return AppLocalizations.of(context)!.thunderstorm;
      case "Drizzle":
        return AppLocalizations.of(context)!.drizzle;
      case "Rain":
        return AppLocalizations.of(context)!.rain;
      case "Snow":
        return AppLocalizations.of(context)!.snow;
      case "Atmosphere":
        return AppLocalizations.of(context)!.atmos;
      case "Clear":
        return AppLocalizations.of(context)!.clear;
      default:
        return AppLocalizations.of(context)!.unknownW;
    }
  }

  static Column getWeatherCardInfo(
      BuildContext context, WeatherData weatherData) {
    String name = fixCityName(weatherData);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          " $name, ${weatherData.sys.country!}",
          style: const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
                "http://openweathermap.org/img/wn/${weatherData.weather[0].icon!}@2x.png"),
            Text(
              "${weatherData.main!.temp.floor()} C\n${getWeatherDescription(context, weatherData.weather[0].main)}",
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  static List<String> weatherListCityNamesToList(List<dynamic> weatherList) {
    List<String> cities = <String>[];
    for (var element in MyApp.weatherList) {
      cities.add(element.name);
    }
    return cities;
  }

  static final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
}
