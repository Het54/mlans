// ignore_for_file: prefer_const_constructors

import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
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
      drawer: Provider.of<ProfileHelpers>(context, listen: false)
          .customDrawer(context),
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
            Provider.of<FeedHelpers>(context, listen: false)
                .premiumBanner(context),
            Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
          ],
        ),
      ),
    );
  }
}
