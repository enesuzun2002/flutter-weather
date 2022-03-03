import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weather/services/weather_shared_prefs.dart';

class FirebaseFuncsProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  WeatherSharedPrefs wsf = WeatherSharedPrefs();

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future googleLogOut() async {
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    wsf.clearSharedPrefs();
    notifyListeners();
  }

  Future firebaseLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future firebaseRegister(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future firebaseForgotPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future firebaseGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
