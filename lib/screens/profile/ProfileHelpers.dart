// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
