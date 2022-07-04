import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../screens/landing_page/landingUtils.dart';
import 'Authentication.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;

  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileImage/${Provider.of<LandingUtils>(context, listen: false).getUserImage.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserImage);

    await imageUploadTask.whenComplete(() {
      print("Image Uploaded!");
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userImageUrl =
          url.toString();
      print(
          "image url: ${Provider.of<LandingUtils>(context, listen: false).userImageUrl}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('userData')
        .doc(Provider.of<Authentication>(context, listen: false).getUser()?.uid)
        .set(data);
  }

  Future addOnboardMembers(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('onBoardMembers')
        .doc(Provider.of<Authentication>(context, listen: false).getUser()?.uid)
        .set(data);
  }

  Future addUser(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance.collection('users').add(data);
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future uploadPostDataInProfile(
      String uid, String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('posts')
        .doc(postId)
        .set(data);
  }

  Future updatePostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future reportPost(String userId, String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("Reports")
        .doc(postId)
        .collection(userId)
        .doc("report")
        .set(data);
  }

  Future activatePremium(String uid, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .update(data);
  }

  Future uploadFeedbackData(String uid, dynamic data) async {
    return FirebaseFirestore.instance.collection('feedback').doc(uid).set(data);
  }

  String generateOnboardCode() {
    Random random = new Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));

    return getRandomString(6);
  }

  onboardMember(String uid, String code) {
    FirebaseFirestore.instance.collection('userData').doc(uid).get().then((value) {
      if (value.data()!['onBoardCode'] == code) {
        print("Code Matched");
        Fluttertoast.showToast(msg: "Yaay, you onboarded your partner!😍");
      }
      else
        Fluttertoast.showToast(msg: "Opps thats not matching🤨");
    });
  }
}
