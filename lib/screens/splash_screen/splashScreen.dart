import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_lans/screens/landing_page/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.fade)));
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/moneyLans.jpg"),
      ),
    );
  }
}
