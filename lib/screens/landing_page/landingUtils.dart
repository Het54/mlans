// ignore_for_file: deprecated_member_use, avoid_print, unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_lans/screens/landing_page/landingServices.dart';
import 'package:provider/provider.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();

  late File userImage;
  File get getUserImage => userImage;

  late String userImageUrl;
  String get getUserImageUrl => userImageUrl;

  Future pickUserImage(BuildContext context, ImageSource source) async {
    final pickedUserImage = await picker.getImage(source: source);
    pickedUserImage == null
        ? print("Select Image")
        : userImage = File(pickedUserImage.path);
    print(userImage.path);

    userImage != null
        ? Provider.of<LandingServices>(context, listen: false)
            .showUserImage(context)
        : print("Image upload error!");
    notifyListeners();
  }

  Future selectUserImageOptionSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          pickUserImage(context, ImageSource.camera)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingServices>(context, listen: false)
                                .showUserImage(context);
                          });
                        },
                        child: Text("Camera")),
                    ElevatedButton(
                        onPressed: () {
                          pickUserImage(context, ImageSource.gallery)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingServices>(context, listen: false)
                                .showUserImage(context);
                          });
                        },
                        child: Text("Gallery")),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
