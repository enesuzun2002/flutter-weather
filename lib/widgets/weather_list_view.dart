import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/variables.dart';
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
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: true);
    if (Variables.firstRun) {
      return FutureBuilder(
        future: reloadProvider.weatherDataReload(),
        builder: (context, snapshot) {
          Variables.firstRun = false;
          if (snapshot.connectionState == ConnectionState.done) {
            if (Variables.weatherList.isEmpty) {
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
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16.0),
                itemCount: Variables.weatherList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: getWeatherCard(
                        context, Variables.weatherList.elementAt(index)),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      if (Variables.weatherList.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context)!.pAddCity,
              style: Theme.of(context).textTheme.bodyLarge),
        );
      } else {
        return ListView.builder(
          itemCount: Variables.weatherList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: getWeatherCard(
                  context, Variables.weatherList.elementAt(index)),
            );
          },
        );
      }
    }
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
                            Variables.unitS == "metric"
                                ? Text("${weatherData.main!.temp.floor()} °C")
                                : Text("${weatherData.main!.temp.floor()} °F"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.feelsL),
                            Variables.unitS == "metric"
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
                            Variables.unitS == "metric"
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
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
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
                      Variables.weatherList.remove(weatherData);
                      wsf.updateCities(
                          hw.weatherListCityNamesToList(Variables.weatherList));
                      refresh();
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<void> refresh() async {
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: false);
    await reloadProvider.weatherDataReload();
    setState(() {});
  }
}
