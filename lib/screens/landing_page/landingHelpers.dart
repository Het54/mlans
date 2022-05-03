// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'landingServices.dart';

class LandingHelpers with ChangeNotifier {
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.png"),
        ),
      ),
    );
  }

  Widget tagLineText(BuildContext context) {
    return Positioned(
      top: 400.0,
      left: 90.0,
      child: Container(
        // ignore: prefer_const_constructors
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: RichText(
          text: TextSpan(
              text: " Welcome ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 32,
              ),
              // ignore: prefer_const_literals_to_create_immutables
              children: <TextSpan>[
                TextSpan(
                  text: "to \n",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                TextSpan(
                  text: "Moneylans",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Positioned(
      top: 580,
      left: MediaQuery.of(context).size.width * 0.25,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 44,
        child: InkWell(
          splashColor: Colors.black,
          onTap: () {
            Provider.of<LandingServices>(context, listen: false)
                .loginSheet(context);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Center(
              child: Text(
                "Log in to Moneylans",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signinButton(BuildContext context) {
    return Positioned(
      top: 530,
      left: MediaQuery.of(context).size.width * 0.25,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 44,
        child: InkWell(
          splashColor: Colors.black,
          onTap: () {
            Provider.of<LandingServices>(context, listen: false)
                .signInSheet(context);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            child: Center(
              child: Text(
                "Sign in to Moneylans",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 650,
      left: 20,
      right: 20,
      child: Container(
          child: Column(
        children: [
          Text(
            "By continuing to this you agree to Moneylans's Terms of",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          Link(
            target: LinkTarget.blank,
            uri:
                Uri.parse("https://pages.flycricket.io/moneylans/privacy.html"),
            builder: (context, followLink) => TextButton(
              child: Text(
                "Services and Privacy Policies",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              onPressed: followLink,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      )),
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(),
                ElevatedButton(onPressed: () {}, child: Text("Sign in"))
              ],
            ),
          );
        });
  }

  displayToast(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }

  progressDialog(BuildContext context, String msg) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              SizedBox(width: 26.0),
              Text(
                msg,
                style: TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
