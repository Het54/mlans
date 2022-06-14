// ignore_for_file: dead_code, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../screens/home_page/homePage.dart';
import '../screens/landing_page/landingHelpers.dart';
import 'FirebaseOperations.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? userUid;
  String? get getUserUid => userUid;


  Future logIntoAccount(
      String email, String password, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Provider.of<LandingHelpers>(context, listen: false)
              .progressDialog(context, "Authenticating, please wait......");
        });

    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      return e.message;
    }
  }

  Future createNewAccount(String name, String phone, String email,
      String password, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Provider.of<LandingHelpers>(context, listen: false)
              .progressDialog(context, "Registering, please wait......");
        });

    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .catchError((errMsg) {
      Navigator.pop(context);
      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid);

      dynamic userDataMap = {
        "name": name.trim(),
        "phone": phone.trim(),
        "email": email.trim(),
        "premium": false,
        "onBoardCode": Provider.of<FirebaseOperations>(context, listen: false)
            .generateOnboardCode(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);

      Provider.of<FirebaseOperations>(context, listen: false)
          .createUserCollection(context, userDataMap);

      Provider.of<LandingHelpers>(context, listen: false).displayToast(
          "Congratulations! your account has been created.", context);

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: HomePage(
                name: name,
              ),
              type: PageTransitionType.bottomToTop),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pop(context);
      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("New user account has not been created!", context);
    }
  }

  Future logOutAccount(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
        context, '/landingpage', (route) => false);
  }

  User? getUser() {
    try {
      return firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("Reset Password link sent!", context);
    } on FirebaseAuthException catch (e) {
      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("${e.message}", context);
    }
  }
}
