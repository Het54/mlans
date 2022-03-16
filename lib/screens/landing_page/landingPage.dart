import 'package:flutter/material.dart';
import 'package:money_lans/screens/landing_page/landingHelpers.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelpers>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .tagLineText(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .loginButton(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .signinButton(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .privacyText(context),
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 0.9],
        colors: [
          Colors.white,
          Colors.indigo.shade400,
        ],
      )),
    );
  }
}
