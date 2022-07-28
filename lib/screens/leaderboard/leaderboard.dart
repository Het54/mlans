import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'leaderboardHelper.dart';
import 'package:intl/intl.dart';

class leaderboard extends StatefulWidget {
  String? userId;
  leaderboard({Key? key, this.userId}) : super(key: key);

  @override
  State<leaderboard> createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  Map l ={};
  String? premium;
  int counter = 0;

  @override
  void initState() {
    DateTime now = DateTime.now();
    String Day = DateFormat('EEEE').format(now);
    String time = DateFormat('hh:mm').format(now);
    if(Day == "Sunday"){
      FirebaseFirestore.instance
        .collection("leaderboard")
        .orderBy('index')
        .get()
        .then((docSnapshot) => {
              for (int i = 0; i < docSnapshot.docs.length; i++)
                {
                  FirebaseFirestore.instance
                    .collection("userData")
                    .doc(docSnapshot.docs[i].data()['userId'])
                    .get()
                    .then((value) => {
                      FirebaseFirestore.instance
                      .collection("leaderboard")
                      .doc(docSnapshot.docs[i].data()['userId'])
                      .update({
                        "premium": value['premium'],
                      })
                    }),
                  if(docSnapshot.docs[i].data()['index'] == 1 && docSnapshot.docs[i].data()['premium'] == true){
                      l = docSnapshot.docs[i].data(),
                      counter = 1,
                    }
                  else if(docSnapshot.docs[i].data()['index'] == 2 && docSnapshot.docs[i].data()['premium'] == true && counter == 0){
                    l = docSnapshot.docs[i].data(),
                    counter = 1,
                  }  
                  else if(docSnapshot.docs[i].data()['index'] == 3 && docSnapshot.docs[i].data()['premium'] == true && counter == 0){
                    l = docSnapshot.docs[i].data(),
                    counter = 1,
                  }
                },
                if(counter == 0){
                  l = docSnapshot.docs[0].data()
                },
                  FirebaseFirestore.instance
                  .collection("leaderboardDetails")
                  .doc("Detail")
                  .update({  
                    "point": l["point"],
                    "product": l["Product"],
                    "Description": l["description"],
                    "Link": l["link"],
                    "userId": l["userId"],
                  })
            });
    }   
    super.initState();
  }
  

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
      body: firebaseTopList(userId: this.widget.userId)
    );
  }
}
