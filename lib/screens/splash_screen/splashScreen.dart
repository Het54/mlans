import 'dart:async';
import 'package:Moneylans/screens/home_page/homePage.dart';
import 'package:Moneylans/screens/splash_screen/introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.pushNamedAndRemoveUntil(
          context,
          FirebaseAuth.instance.currentUser == null ? '/landingpage' : '/home',
          (Route<dynamic> route) => false);
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }


  @override
  void initState() {
    checkFirstSeen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/mlans.jpg",
        ),
      ),
    );
  }
}
