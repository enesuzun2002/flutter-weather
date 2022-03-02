import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static final TextEditingController emailEditingController =
      TextEditingController();

  static final StreamController<int> controller =
      StreamController<int>.broadcast();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordEditingController =
      TextEditingController();
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.getAppBar(AppLocalizations.of(context)!.logIn),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.emailHint,
                            icon: const Icon(Icons.person)),
                        autocorrect: false,
                        autofocus: true,
                        enableSuggestions: false,
                        controller: Login.emailEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.emailEmpty;
                          } else if (!CustomWidgets.emailRegex
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!.emailInvalid;
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            email = Login.emailEditingController.text,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.passHint,
                            icon: const Icon(Icons.password)),
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
                  )),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final provider = Provider.of<FirebaseFuncsProvider>(
                          context,
                          listen: false);
                      provider.firebaseLogin(email, password);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.logInB)),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: Text(AppLocalizations.of(context)!.gSignIn)),
              ElevatedButton(
                  onPressed: () {
                    Login.controller.add(1);
                  },
                  child: Text(AppLocalizations.of(context)!.registerB)),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.firebaseForgotPass(email);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text(
                            AppLocalizations.of(context)!.passResetSnack)));
                  },
                  child: Text(AppLocalizations.of(context)!.passResetB)),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.firebaseGuest();
                  },
                  child: Text(AppLocalizations.of(context)!.guestB)),
            ],
          ),
        ),
      ),
    );
  }
}
