import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherListView extends StatefulWidget {
  const WeatherListView({Key? key}) : super(key: key);

  @override
  State<WeatherListView> createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  @override
  Widget build(BuildContext context) {
    CustomWidgets cw = CustomWidgets();
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: true);
    if (MyApp.firstRun) {
      return FutureBuilder(
        future: reloadProvider.weatherDataReloadSharedPrefs(),
        builder: (context, snapshot) {
          MyApp.firstRun = false;
          if (snapshot.connectionState == ConnectionState.done) {
            if (MyApp.weatherList.isEmpty) {
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
                itemCount: MyApp.weatherList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: getWeatherCard(
                        context, MyApp.weatherList.elementAt(index)),
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
      if (MyApp.weatherList.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context)!.pAddCity,
              style: Theme.of(context).textTheme.bodyLarge),
        );
      } else {
        return ListView.builder(
          itemCount: MyApp.weatherList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  getWeatherCard(context, MyApp.weatherList.elementAt(index)),
            );
          },
        );
      }
    }
  }

  InkWell getWeatherCard(BuildContext context, WeatherData weatherData) {
    CustomWidgets cw = CustomWidgets();
    return InkWell(
      onTap: () => weatherCardExpanded(context, weatherData),
      onLongPress: () => weatherRemoveAlert(context, weatherData),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          height: 179.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: cw.getColor(weatherData),
              borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: cw.getWeatherCardInfo(context, weatherData),
          ),
        ),
      ),
    );
  }

  Future<dynamic> weatherCardExpanded(
      BuildContext context, WeatherData weatherData) {
    CustomWidgets cw = CustomWidgets();
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text(
              "${cw.fixCityName(weatherData)}, ${weatherData.sys.country}",
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
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.temp),
                            Text("${weatherData.main!.temp.floor()} °C"),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.feelsL),
                            Text("${weatherData.main!.feelsLike} °C"),
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
                            Text("${weatherData.wind!.speed} m/s"),
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
                            style: TextStyle(fontSize: 20.0)),
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
    CustomWidgets cw = CustomWidgets();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.removeConf),
              content: Text(
                  "${AppLocalizations.of(context)!.removeDesc} ${cw.fixCityName(weatherData)}"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancelB)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      MyApp.weatherList.remove(weatherData);
                      wsf.updateCities(
                          cw.weatherListCityNamesToList(MyApp.weatherList));
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
