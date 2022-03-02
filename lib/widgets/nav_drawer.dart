import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/services/firebase_funcs_provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final Stream<int> stream = MyApp.controller.stream;
  @override
  void initState() {
    stream.listen((event) {
      MyApp.selectedDestination = event;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Weather',
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            MyApp.selectedDestination == 2
                ? ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    selected: MyApp.selectedDestination == 0,
                    onTap: () {
                      MyApp.controller.add(0);
                    },
                  )
                : Container(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              selected: MyApp.selectedDestination == 2,
              onTap: () {
                MyApp.controller.add(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              selected: MyApp.selectedDestination == 4,
              onTap: () {
                MyApp.controller.add(4);
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Account',
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                final provider =
                    Provider.of<FirebaseFuncsProvider>(context, listen: false);
                provider.googleLogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
