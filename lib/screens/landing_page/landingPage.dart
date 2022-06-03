import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'landingHelpers.dart';

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
      color: Colors.white,
    );
  }
}
