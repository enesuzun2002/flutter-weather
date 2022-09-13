import 'package:flutter/material.dart';
import 'package:weather/pages/main_page.dart';
import 'package:weather/pages/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/variables.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Wrap(
                runSpacing: 16,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Text(AppLocalizations.of(context)!.home),
                    selected: Variables.selectedIndex == 0,
                    onTap: () {
                      if (Variables.selectedIndex != 0) {
                        Variables.selectedIndex = 0;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const MainPage()));
                        setState(() {});
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(AppLocalizations.of(context)!.settings),
                    selected: Variables.selectedIndex == 1,
                    onTap: () {
                      if (Variables.selectedIndex != 1) {
                        Variables.selectedIndex = 1;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Settings()));
                        setState(() {});
                      }
                    },
                  ),
                  /* ListTile(
                    leading: const Icon(Icons.info_outlined),
                    title: Text(AppLocalizations.of(context)!.about),
                    selected: MyApp.selectedIndex == 2,
                    onTap: () {
                      if (MyApp.selectedIndex != 2) {
                        MyApp.selectedIndex = 2;
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => About()));
                        setState(() {});
                      }
                    },
                  ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
