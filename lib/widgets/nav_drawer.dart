import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/pages/about.dart';
import 'package:weather/pages/profile.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                onTap: () {
                  if (MyApp.selectedIndex != -1) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Profile()));
                    MyApp.selectedIndex = -1;
                  }
                },
                child: Container(
                    padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).viewPadding.top) + 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45.0,
                          backgroundImage: user == null || user.photoURL == null
                              ? const NetworkImage(
                                  "http://getdrawings.com/free-icon/generic-avatar-icon-68.png")
                              : NetworkImage("${user.photoURL}"),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          user == null ||
                                  user.displayName == null ||
                                  user.isAnonymous
                              ? AppLocalizations.of(context)!.profile
                              : user.displayName!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Wrap(
                runSpacing: 16,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Text(AppLocalizations.of(context)!.home),
                    selected: MyApp.selectedIndex == 0,
                    onTap: () {
                      if (MyApp.selectedIndex != 0) {
                        MyApp.selectedIndex = 0;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const MainPage()));
                        setState(() {});
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(AppLocalizations.of(context)!.settings),
                    selected: MyApp.selectedIndex == 1,
                    onTap: () {
                      if (MyApp.selectedIndex != 1) {
                        MyApp.selectedIndex = 1;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Settings()));
                        setState(() {});
                      }
                    },
                  ),
                  ListTile(
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
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(AppLocalizations.of(context)!.logOut),
                    onTap: () {
                      final provider = Provider.of<FirebaseFuncsProvider>(
                          context,
                          listen: false);
                      provider.googleLogOut();
                      MainPage.controller.add(1);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MainPage()));
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
