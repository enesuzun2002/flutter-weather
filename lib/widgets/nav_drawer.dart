import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/firebase_funcs_provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int _selectedDestination = 0;
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              selected: _selectedDestination == 0,
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
