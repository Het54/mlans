import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? userUid;
  String? get getUserUid => userUid;

  Future logIntoAccount(String email, String password) async {
    // try {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    print(userUid);
    notifyListeners();
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // }
  }

  Future createNewAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    print('Created account : $userUid');
    notifyListeners();
  }

  Future logOutAccount() {
    return firebaseAuth.signOut();
  }
}
