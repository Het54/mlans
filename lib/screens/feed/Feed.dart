// ignore_for_file: prefer_const_constructors

import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import 'FeedHelpers.dart';

class Feed extends StatelessWidget {
  Feed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Moneylans",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<FeedHelpers>(context, listen: false)
              .uploadPostSheet(context);
        },
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUser()
                      ?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data!.get('premium') == false
                      ? Provider.of<FeedHelpers>(context, listen: false)
                          .premiumBanner(context)
                      : Container();
                }
              },
            ),
            Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
          ],
        ),
      ),
    );
  }
}
