import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/Authentication.dart';

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
}
