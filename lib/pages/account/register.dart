import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/account/login.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  CustomWidgets cw = CustomWidgets();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _passwordCEditingController =
      TextEditingController();
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  String email = "";
  String password = "";
  String passwordC = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cw.getAppBar(AppLocalizations.of(context)!.register),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Container(
                width: 110.0,
                height: 110.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  image: DecorationImage(
                      image: AssetImage('assets/icon/icon.png')),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Form(
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
                          } else if (!cw.emailRegex.hasMatch(value)) {
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
                          label:
                              Text(AppLocalizations.of(context)!.passConfHint),
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
                  )),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final provider = Provider.of<FirebaseFuncsProvider>(
                              context,
                              listen: false);
                          provider.firebaseRegister(email, password);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                  AppLocalizations.of(context)!.registerScss)));
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.registerB)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
