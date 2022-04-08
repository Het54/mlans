import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:money_lans/services/Authentication.dart';
import 'package:provider/provider.dart';

import '../screens/landing_page/landingUtils.dart';

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

  Future addUser(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance.collection('users').add(data);
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future updatePostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }
}
