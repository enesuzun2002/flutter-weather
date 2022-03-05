import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomWidgets {
  Color getColor(WeatherData weatherData) {
    switch (weatherData.weather[0].main) {
      case "Clouds":
        return const Color.fromRGBO(50, 52, 86, 100);
      case "Thunderstorm":
        return const Color.fromRGBO(47, 206, 210, 100);
      case "Drizzle":
        return const Color.fromRGBO(255, 184, 37, 100);
      case "Rain":
        return const Color.fromRGBO(86, 111, 151, 100);
      case "Snow":
        return const Color.fromRGBO(127, 164, 178, 100);
      case "Atmosphere":
        return const Color.fromRGBO(91, 100, 221, 100);
      case "Clear":
        return const Color.fromRGBO(51, 153, 255, 100);
      default:
        return const Color.fromRGBO(51, 153, 255, 100);
    }
  }

  Icon buildNavIcon(IconData iconData, bool active) {
    return Icon(iconData, size: 20.0);
  }

  AppBar getAppBar(String header) {
    return AppBar(
        centerTitle: true,
        title: Text(
          header,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ));
  }

  Future<int> getData(String city, String apiKey) async {
    WeatherData weatherData = WeatherData();
    WeatherApiClient client = WeatherApiClient();
    weatherData = await client.getWeatherData(city, apiKey);
    // Cod 404 is returned for wrong location name.
    // Cod 401 is returned for wrong api key.
    if (weatherData.cod == 404) {
      return weatherData.cod;
    } else if (weatherData.cod == 401) {
      return weatherData.cod;
    } else {
      for (var element in MyApp.weatherList) {
        if (element.name == weatherData.name) {
          MyApp.weatherList.remove(element);
          MyApp.weatherList.add(weatherData);
          return weatherData.cod;
        }
      }
      MyApp.weatherList.add(weatherData);
    }
    return weatherData.cod;
  }

  Padding getWeatherCard(BuildContext context, WeatherData weatherData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 179.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: getColor(weatherData),
            borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: getWeatherCardInfo(context, weatherData),
        ),
      ),
    );
  }

  Container getProgressIndicatorCard() {
    return Container(
      height: 150.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 153, 65, 6),
          borderRadius: BorderRadius.circular(16.0)),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  String fixCityName(WeatherData weatherData) {
    String name = "";
    if (weatherData.name.toString().contains("Province")) {
      name = weatherData.name.toString().split(" ").first;
    } else {
      name = weatherData.name.toString();
    }
    return name;
  }

  String getWeatherDescription(BuildContext context, String weatherDesc) {
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

  Column getWeatherCardInfo(BuildContext context, WeatherData weatherData) {
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

  List<String> weatherListCityNamesToList(List<dynamic> weatherList) {
    List<String> cities = <String>[];
    for (var element in MyApp.weatherList) {
      cities.add(element.name);
    }
    return cities;
  }

  Container getAppImage() {
    return Container(
      width: 110.0,
      height: 110.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
        image: DecorationImage(image: AssetImage('assets/icon/icon.png')),
      ),
    );
  }

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
}
