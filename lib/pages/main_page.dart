import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:weather/controller/reload_weather_data.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/services/prefs_helper.dart';
import 'package:weather/widgets/helper_widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static final StreamController<int> controller =
      StreamController<int>.broadcast();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Stream<int> stream = MainPage.controller.stream;

  int pageIndex = 1;

  @override
  void initState() {
    stream.listen((event) {
      pageIndex = event;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  HelperWidgets hw = HelperWidgets();

  final pages = [
    const Home(),
    const Search(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: pageIndex == 0
            ? Text(AppLocalizations.of(context)!.weather,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold))
            : pageIndex == 1
                ? Text(AppLocalizations.of(context)!.addNewCity,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))
                : Text(AppLocalizations.of(context)!.settings,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
        actions: [
          if (pageIndex == 0)
            IconButton(
              onPressed: () {
                if (!PrefsHelper.reload && !PrefsHelper.isRunning) {
                  PrefsHelper.isRunning = true;
                  Timer(const Duration(minutes: 3), () {
                    PrefsHelper.reload = true;
                    PrefsHelper.isRunning = false;
                  });
                }
                if (PrefsHelper.reload) {
                  Get.find<ReloadWeatherDataController>().weatherDataReload();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(AppLocalizations.of(context)!.scfReload)));
                  PrefsHelper.reload = false;
                  // Create a new timer after refreshing so that user don't have to wait 60 secs everytime they try to refresh.
                  // Also add a guard so this only works if reload is false.
                  if (!PrefsHelper.reload && !PrefsHelper.isRunning) {
                    PrefsHelper.isRunning = true;
                    Timer(const Duration(minutes: 3), () {
                      PrefsHelper.reload = true;
                      PrefsHelper.isRunning = false;
                    });
                  }
                } else {
                  if (!PrefsHelper.isShown) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content:
                            Text(AppLocalizations.of(context)!.reloadWait)));
                    PrefsHelper.isShown = true;
                    Timer(const Duration(seconds: 30), () {
                      PrefsHelper.isShown = false;
                    });
                  }
                }
              },
              icon: const Icon(Icons.replay_outlined),
            ),
        ],
      ),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        height: 70.0,
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              label: AppLocalizations.of(context)!.home),
          NavigationDestination(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.search),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: AppLocalizations.of(context)!.settings),
        ],
      ),
    );
  }
}
