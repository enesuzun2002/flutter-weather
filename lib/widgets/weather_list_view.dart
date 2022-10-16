import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controller/weather.dart';
import 'package:weather/services/prefs_helper.dart';
import 'package:weather/model/weather_data.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherListView extends StatefulWidget {
  const WeatherListView({Key? key}) : super(key: key);

  @override
  State<WeatherListView> createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: WeatherController.weatherListViewId,
      builder: (WeatherController controller) {
        if (PrefsHelper.weatherDataList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.pAddCity),
              ],
            ),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: PrefsHelper.weatherDataList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: getWeatherCard(
                    context, PrefsHelper.weatherDataList.elementAt(index)),
              );
            },
          );
        }
      },
    );
  }

  InkWell getWeatherCard(BuildContext context, WeatherData weatherData) {
    HelperWidgets hw = HelperWidgets();
    return InkWell(
      onTap: () => weatherCardExpanded(context, weatherData),
      onLongPress: () => weatherRemoveAlert(context, weatherData),
      child: Card(
        color: hw.getColor(weatherData),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: hw.getWeatherCardInfo(context, weatherData),
        ),
      ),
    );
  }

  Future<dynamic> weatherCardExpanded(
      BuildContext context, WeatherData weatherData) {
    HelperWidgets hw = HelperWidgets();
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text(
              "${hw.fixCityName(weatherData)}, ${weatherData.sys.country}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.general,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.temp),
                            PrefsHelper.unitS == "metric"
                                ? Text("${weatherData.main!.temp.floor()} °C")
                                : Text("${weatherData.main!.temp.floor()} °F"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.feelsL),
                            PrefsHelper.unitS == "metric"
                                ? Text("${weatherData.main!.feelsLike} °C")
                                : Text("${weatherData.main!.feelsLike} °F"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.humidity),
                            Text("${weatherData.main!.humidity}%"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.windS),
                            PrefsHelper.unitS == "metric"
                                ? Text("${weatherData.wind!.speed} m/s")
                                : Text("${weatherData.wind!.speed} m/h"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.windD),
                            Text("${weatherData.wind!.deg} °"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.cloudNs),
                            Text("${weatherData.clouds!.all}%"),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(AppLocalizations.of(context)!.coords,
                            style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.long),
                            Text("${weatherData.coord!.lon}"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.lat),
                            Text("${weatherData.coord!.lat}"),
                          ],
                        ),
                      ]),
                ),
              )
            ],
          );
        });
  }

  Future<dynamic> weatherRemoveAlert(
      BuildContext context, WeatherData weatherData) {
    HelperWidgets hw = HelperWidgets();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.removeConf),
              content: Text(
                  "${AppLocalizations.of(context)!.removeDesc} ${hw.fixCityName(weatherData)}"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancelB)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Get.find<WeatherController>().removeCity(weatherData);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }
}
