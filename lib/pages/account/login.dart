import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/widgets/custom_widgets.dart';

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
      appBar: CustomWidgets.getAppBar("Login"),
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
                        decoration: const InputDecoration(
                            hintText: "Type in your email...",
                            icon: Icon(Icons.person)),
                        autocorrect: false,
                        autofocus: true,
                        enableSuggestions: false,
                        controller: Login.emailEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!CustomWidgets.emailRegex
                              .hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            email = Login.emailEditingController.text,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: const InputDecoration(
                            hintText: "Type in your password...",
                            icon: Icon(Icons.password)),
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _passwordEditingController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
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
                    } else {
                      print('Error');
                    }
                  },
                  child: const Text("Login")),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: const Text("Sign in with Google")),
              ElevatedButton(
                  onPressed: () {
                    Login.controller.add(1);
                  },
                  child: const Text("Register")),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.firebaseForgotPass(email);
                    print(email);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(
                            "Check your email for password resetting...")));
                  },
                  child: const Text("Forgot My Password")),
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.firebaseGuest();
                  },
                  child: const Text("Continue as guest")),
            ],
          ),
        ),
      ),
    );
  }
}
