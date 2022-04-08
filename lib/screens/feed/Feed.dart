// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_lans/services/Authentication.dart';

import 'FeedHelpers.dart';

class Feed extends StatelessWidget {
  Feed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<FeedHelpers>(context, listen: false)
              .uploadPostSheet(context);
        },
      ),
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
