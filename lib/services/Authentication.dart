import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:money_lans/main.dart';
import 'package:money_lans/screens/landing_page/landingHelpers.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../screens/home_page/homePage.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? userUid;
  String? get getUserUid => userUid;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future logIntoAccount(
      String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future createNewAccount(String name, String phone, String email,
      String password, BuildContext context) async {
    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .catchError((errMsg) {
      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": name.trim(),
        "phone": phone.trim(),
        "email": email.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      Provider.of<LandingHelpers>(context, listen: false).displayToast(
          "Congratulations! your account has been created.", context);

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.bottomToTop),
          (Route<dynamic> route) => false);
    } else {
      Provider.of<LandingHelpers>(context, listen: false)
          .displayToast("New user account has not been created!", context);
    }
  }

  Future logOutAccount() {
    return firebaseAuth.signOut();
  }

  User? getUser() {
    try {
      return firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}
