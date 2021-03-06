import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:weather/pages/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  HelperWidgets hw = HelperWidgets();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: hw.getAppBar(
          user == null || user.displayName == null || user.isAnonymous
              ? AppLocalizations.of(context)!.profile
              : user.displayName!),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: user == null ||
                          user.photoURL == null ||
                          user.isAnonymous
                      ? const NetworkImage(
                          "http://getdrawings.com/free-icon/generic-avatar-icon-68.png")
                      : NetworkImage("${user.photoURL}"),
                )),
          ),
        ]),
      ),
    );
  }
}
