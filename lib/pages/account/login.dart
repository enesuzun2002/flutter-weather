import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static final TextEditingController emailEditingController =
      TextEditingController();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordEditingController =
      TextEditingController();
  CustomWidgets cw = CustomWidgets();
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cw.getAppBar(AppLocalizations.of(context)!.logIn),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              cw.getAppImage(),
              const SizedBox(
                height: 16.0,
              ),
              getLogInForm(context),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Wrap(
                  runSpacing: 12.0,
                  children: [
                    getLogInB(context),
                    getGoogleLogInB(context),
                    getForgotPassB(context),
                    getGuestB(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form getLogInForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              key: _emailFieldKey,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.emailHint),
              ),
              autocorrect: false,
              enableSuggestions: false,
              controller: Login.emailEditingController,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.emailEmpty;
                } else if (!cw.emailRegex.hasMatch(value)) {
                  return AppLocalizations.of(context)!.emailInvalid;
                }
                return null;
              },
              onChanged: (value) => email = Login.emailEditingController.text,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.passHint),
              ),
              autocorrect: false,
              enableSuggestions: false,
              controller: _passwordEditingController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.passEmpty;
                }
                return null;
              },
              onChanged: (value) => password = value,
            ),
          ],
        ));
  }

  SizedBox getLogInB(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            MyApp.firstInstall = await wsf.getFirstInstall();
            if (_formKey.currentState!.validate()) {
              if (MyApp.firstInstall) {
                firstInstallAlert(context);
                MyApp.firstInstall = false;
                wsf.updateFirstInstall(false);
              }
              final provider =
                  Provider.of<FirebaseFuncsProvider>(context, listen: false);
              provider.firebaseLogin(email, password);
            }
          },
          child: Text(AppLocalizations.of(context)!.logInB)),
    );
  }

  SizedBox getGoogleLogInB(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            MyApp.firstInstall = await wsf.getFirstInstall();
            if (MyApp.firstInstall) {
              firstInstallAlert(context);
              MyApp.firstInstall = false;
              wsf.updateFirstInstall(false);
            }
            final provider =
                Provider.of<FirebaseFuncsProvider>(context, listen: false);
            provider.googleLogin();
          },
          child: Text(AppLocalizations.of(context)!.gSignIn)),
    );
  }

  SizedBox getForgotPassB(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            if (_emailFieldKey.currentState!.validate()) {
              final provider =
                  Provider.of<FirebaseFuncsProvider>(context, listen: false);
              provider.firebaseForgotPass(email);
              if (!MyApp.isShown) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    content:
                        Text(AppLocalizations.of(context)!.passResetSnack)));
                MyApp.isShown = true;
                Timer(const Duration(seconds: 30), () {
                  MyApp.isShown = false;
                });
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.passResetB)),
    );
  }

  SizedBox getGuestB(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            MyApp.firstInstall = await wsf.getFirstInstall();
            if (MyApp.firstInstall) {
              firstInstallAlert(context);
              MyApp.firstInstall = false;
              wsf.updateFirstInstall(false);
            }
            final provider =
                Provider.of<FirebaseFuncsProvider>(context, listen: false);
            provider.firebaseGuest();
          },
          child: Text(AppLocalizations.of(context)!.guestB)),
    );
  }

  Future<dynamic> firstInstallAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.firstLaunchLogin),
              content: Text(AppLocalizations.of(context)!.firstLaunchAlert),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }
}
