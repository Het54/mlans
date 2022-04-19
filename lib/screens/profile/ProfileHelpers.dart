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
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black87),
                accountName: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userData')
                      .doc(
                          "${Provider.of<Authentication>(context, listen: false).getUser()?.uid}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text("Hola " + snapshot.data!.get('name') + ",",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20));
                    }
                  },
                ),
                accountEmail: Text(
                  Provider.of<Authentication>(context, listen: false)
                      .getUser()!
                      .uid,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Divider(
                  height: 5,
                  thickness: 1,
                  color: Colors.white,
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
                      "Join our Reddit Community",
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
                  EvaIcons.logOutOutline,
                  color: Colors.white,
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
                    "Logout from Moneylans",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
