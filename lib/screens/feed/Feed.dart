// ignore_for_file: prefer_const_constructors

import 'package:Moneylans/screens/leaderboard/leaderboard.dart';
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
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5.0,
        title: const Text(
          "Moneylans",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => leaderboard(userId : Provider.of<Authentication>(context, listen: false)
                              .getUser()
                              ?.uid))));
                },
                child: Icon(Icons.leaderboard,color: Colors.black,)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<FeedHelpers>(context, listen: false)
              .uploadPostSheet(context);
        },
      ),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}
