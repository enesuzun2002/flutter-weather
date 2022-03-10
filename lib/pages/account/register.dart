import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/account/login.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/variables.dart';
import 'package:weather/widgets/dialog_widgets.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  HelperWidgets hw = HelperWidgets();
  DialogWidgets dw = DialogWidgets();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _passwordCEditingController =
      TextEditingController();
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  String email = "";
  String password = "";
  String passwordC = "";
  final _formKey = GlobalKey<FormState>();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hw.getAppBar(AppLocalizations.of(context)!.register),
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
              getRegisterForm(context),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: getResigterB(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form getRegisterForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
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
              onChanged: (value) => email = value,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              key: _passwordFieldKey,
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
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.passConfHint),
              ),
              autocorrect: false,
              enableSuggestions: false,
              controller: _passwordCEditingController,
              obscureText: true,
              validator: (value) {
                if (value != _passwordFieldKey.currentState!.value) {
                  return AppLocalizations.of(context)!.passMatchErr;
                } else if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.passConfEmpty;
                }
                return null;
              },
              onChanged: (value) => passwordC = value,
            ),
          ],
        ));
  }

  SizedBox getResigterB(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            Variables.firstInstall = await wsf.getFirstInstall();
            if (_formKey.currentState!.validate()) {
              if (Variables.firstInstall) {
                dw.firstInstallAlert(
                    context, AppLocalizations.of(context)!.firstLaunchRegister);
                Variables.firstInstall = false;
                wsf.updateFirstInstall(false);
              }
              final provider =
                  Provider.of<FirebaseFuncsProvider>(context, listen: false);
              provider.firebaseRegister(email, password);
            }
          },
          child: Text(AppLocalizations.of(context)!.registerB)),
    );
  }
}
