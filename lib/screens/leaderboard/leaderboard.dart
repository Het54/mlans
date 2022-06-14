import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'leaderboardHelper.dart';

class leaderboard extends StatelessWidget {
  String? userId;
  leaderboard({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //elevation: 5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Provider.of<leaderboardHelper>(context, listen: false)
          .firebaseTopList(context,this.userId)
    );
  }
}
