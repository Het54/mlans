import 'package:flutter/material.dart';
import 'package:money_lans/screens/landing_page/landingHelpers.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            bodyColor(context),
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
      ),
    );
  }

  bodyColor(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
