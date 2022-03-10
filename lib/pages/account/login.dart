import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/variables.dart';
import 'package:weather/widgets/dialog_widgets.dart';
import 'package:weather/widgets/helper_widgets.dart';
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
  HelperWidgets hw = HelperWidgets();
  DialogWidgets dw = DialogWidgets();
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hw.getAppBar(AppLocalizations.of(context)!.logIn),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              hw.getAppImage(),
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
                } else if (!hw.emailRegex.hasMatch(value)) {
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
            Variables.firstInstall = await wsf.getFirstInstall();
            if (_formKey.currentState!.validate()) {
              if (Variables.firstInstall) {
                dw.firstInstallAlert(
                    context, AppLocalizations.of(context)!.firstLaunchLogin);
                Variables.firstInstall = false;
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
            Variables.firstInstall = await wsf.getFirstInstall();
            if (Variables.firstInstall) {
              dw.firstInstallAlert(
                  context, AppLocalizations.of(context)!.firstLaunchLogin);
              Variables.firstInstall = false;
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
              if (!Variables.isShown) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    content:
                        Text(AppLocalizations.of(context)!.passResetSnack)));
                Variables.isShown = true;
                Timer(const Duration(seconds: 30), () {
                  Variables.isShown = false;
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
            Variables.firstInstall = await wsf.getFirstInstall();
            if (Variables.firstInstall) {
              dw.firstInstallAlert(
                  context, AppLocalizations.of(context)!.firstLaunchLogin);
              Variables.firstInstall = false;
              wsf.updateFirstInstall(false);
            }
            final provider =
                Provider.of<FirebaseFuncsProvider>(context, listen: false);
            provider.firebaseGuest();
          },
          child: Text(AppLocalizations.of(context)!.guestB)),
    );
  }
}
