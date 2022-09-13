import 'package:flutter/material.dart';
import 'package:weather/model/weather_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/services/weather_prefs_helper.dart';

class HelperWidgets {
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

  AppBar getAppBar(String header) {
    return AppBar(
        centerTitle: true,
        title: Text(
          header,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ));
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
        const SizedBox(
          height: 10.0,
        ),
        Text(
          " $name, ${weatherData.sys.country!}",
          style: const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
                "http://openweathermap.org/img/wn/${weatherData.weather[0].icon!}@2x.png"),
            PrefsHelper.unitS == "metric"
                ? Text(
                    "${weatherData.main!.temp.floor()} °C\n${getWeatherDescription(context, weatherData.weather[0].main)}",
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : Text(
                    "${weatherData.main!.temp.floor()} °F\n${getWeatherDescription(context, weatherData.weather[0].main)}",
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
    for (var element in PrefsHelper.weatherDataList) {
      cities.add(element.name);
    }
    cities.sort();
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

  BoxDecoration activeBox(BuildContext context, bool isActive) {
    if (isActive) {
      return BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 2.5),
          borderRadius: BorderRadius.circular(10.0));
    }
    return BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.background.withOpacity(0),
            width: 2.5));
  }
}
