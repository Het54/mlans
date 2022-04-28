// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

import '../../services/Authentication.dart';

class ProfileHelpers with ChangeNotifier {
  logoutDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            Text("Are you sure you want to logout?"),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Provider.of<Authentication>(context, listen: false)
                          .logOutAccount(context);
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<DatabaseEvent> getData(BuildContext context) async {
    String uid =
        '${Provider.of<Authentication>(context, listen: false).getUser()?.uid}';
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(uid)
        .child('name');
    return await dbRef.once();
  }

  customDrawer(BuildContext context) {
    return Dialog(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            color: Colors.black,
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 220.0),
                    child: Container(
                      child: GestureDetector(
                          child: Icon(Icons.close, color: Colors.white),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.discord,
                      color: Colors.white,
                    ),
                    title: Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse("https://discord.gg/atbYDyej"),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(
                          "Join our Discord Community",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider(
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.reddit,
                      color: Colors.white,
                    ),
                    title: Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse(
                          "https://www.reddit.com/r/Moneylans/?utm_medium=android_app&utm_source=share"),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(
                          "Join our Reddit Community           ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider(
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    title: Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse(
                          "https://api.whatsapp.com/send/?phone=%2B917417281718&text&app_absent=0"),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(
                          "Contact our customer support",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider(
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.googlePlay,
                      color: Colors.white,
                    ),
                    title: Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse(
                          "https://play.google.com/store/apps/details?id=com.company.moneylans"),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(
                          "Share Moneylans                    ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Divider(
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      EvaIcons.logOutOutline,
                      color: Colors.red,
                    ),
                    title: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Provider.of<ProfileHelpers>(context,
                                      listen: false)
                                  .logoutDialog(context);
                            });
                      },
                      child: Text(
                        "Logout from Moneylans            ",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
