import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:weather/pages/nav_drawer.dart';

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
    Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hw.getAppBar(pageIndex == 0
          ? AppLocalizations.of(context)!.weather
          : AppLocalizations.of(context)!.addNewCity),
      drawer: const NavDrawer(),
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
              icon: pageIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: AppLocalizations.of(context)!.home),
          NavigationDestination(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.search),
        ],
      ),
    );
  }
}
