import 'package:flutter/material.dart';
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
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 16)),
      ),
      body: firebaseTopList(userId: userId)
    );
  }
}
