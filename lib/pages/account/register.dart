import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/account/login.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/widgets/custom_widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      appBar: CustomWidgets.getAppBar("Register"),
      body: Padding(
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
                        } else if (!CustomWidgets.emailRegex.hasMatch(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      onChanged: (value) => email = value,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      key: _passwordFieldKey,
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
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: const InputDecoration(
                          hintText: "Confirm your password...",
                          icon: Icon(Icons.password)),
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _passwordCEditingController,
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordFieldKey.currentState!.value) {
                          return 'Password do not match';
                        } else if (value!.isEmpty) {
                          return 'Please confirm your password';
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
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final provider = Provider.of<FirebaseFuncsProvider>(context,
                        listen: false);
                    provider.firebaseRegister(email, password);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content:
                            Text("Successfully registered logging in...")));
                  } else {
                    print('Error');
                  }
                },
                child: const Text("Register")),
            ElevatedButton(
                onPressed: () {
                  Login.controller.add(0);
                },
                child: const Text("Go Back")),
          ],
        ),
      ),
    );
  }
}
