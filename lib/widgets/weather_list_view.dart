import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherListView extends StatelessWidget {
  const WeatherListView({
    Key? key,
  }) : super(key: key);

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
                    child: cw.getWeatherCard(
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
          child: Text(AppLocalizations.of(context)!.pAddCity),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: MyApp.weatherList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: cw.getWeatherCard(
                    context, MyApp.weatherList.elementAt(index)),
              );
            },
          ),
        );
      }
    }
  }
}
