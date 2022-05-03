import 'dart:ui';
import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJkqaMY2BZD5-jwCaWlcBTTjamnzlMthxazA&usqp=CAU"),
              fit: BoxFit.cover,
            ),
          ),
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: new Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You need to be a premium member",
                    style: TextStyle(color: Colors.white)),
                Text("to access this feature :(",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                ElevatedButton(
                  child: Text("Join the premium gang now🔥"),
                  onPressed: () {
                    Provider.of<LandingHelpers>(context, listen: false)
                        .displayToast("Coming Soon!🔥", context);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
