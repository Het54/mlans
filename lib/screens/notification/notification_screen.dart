import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../leaderboard/leaderboardHelper.dart';

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  List getter = [];
  List notifi = [];
  List reversednotifi = [];
  var date;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var points;

  @override
  void initState() {
    FirebaseFirestore.instance
    .collection('leaderboard')
    .doc(uid)
    .get()
    .then((value) => {
      points = value.data()!['point'],
    });
    super.initState();
  }

  Future getlist() async{
    print(uid);
    await FirebaseFirestore.instance
    .collection('notifications getter')
    .doc(uid)
    .collection(uid)
    .get()
    .then((docSnapshot) async => {
      for(int i =0 ; i< docSnapshot.docs.length ; i++)
      {
        await FirebaseFirestore.instance
        .collection('notifications')
        .doc(uid)
        .collection(docSnapshot.docs[i].id)
        .get()
        .then((docSnapshot) => {
          notifi.add(docSnapshot.docs[0].data())
        })
      },
    });
    reversednotifi = new List.from(notifi.reversed);
    return(reversednotifi);
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5.0,
        title: const Text(
          "Activity",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
            Expanded(
                    child: FutureBuilder(
                      future: getlist(),
                      builder: (context, AsyncSnapshot) {
                        return ListView.builder(
                        itemCount: reversednotifi.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              onTap:(){
                                Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => feedBody(context,uid,points * 10),
                                    ),
                                  );
                              },
                              title: Text(reversednotifi[index]['notification'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,  color: Color.fromARGB(255, 90, 138, 179)),),
                              subtitle: Text('Date: '+reversednotifi[index]['Date'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,  color: Color.fromARGB(255, 88, 88, 88)),),
                              dense: true,
                              tileColor: Color.fromARGB(255, 235, 235, 235),
                            ),
                          );
                        },
                      );
                      }
                    ),
                  )
          ]
      ),
    );
  }
}