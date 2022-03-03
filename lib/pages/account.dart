import 'package:flutter/material.dart';
import 'package:weather/pages/account/login.dart';
import 'package:weather/pages/account/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);
  static int pageIndex = 0;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  static final pages = [
    const Login(),
    const Register(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[Account.pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: Account.pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            Account.pageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.login),
              label: AppLocalizations.of(context)!.logIn),
          NavigationDestination(
              icon: const Icon(Icons.logout),
              label: AppLocalizations.of(context)!.register),
        ],
      ),
    );
  }
}
