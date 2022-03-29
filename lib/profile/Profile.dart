// ignore_for_file: unnecessary_brace_in_string_interps, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:money_lans/profile/ProfileHelpers.dart';
import 'package:money_lans/services/Authentication.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? uid =
        Provider.of<Authentication>(context, listen: false).getUser()?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Provider.of<ProfileHelpers>(context, listen: false)
                          .logoutDialog(context);
                    });
              },
              icon: Icon(
                EvaIcons.logOut,
                color: Colors.red,
              ))
        ],
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
        child: Column(
          children: [
            profileBio(),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time')
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(child: profilePosts(context, snapshot));
                  }
                }))
          ],
        ),
      ),
    );
  }
}

Widget profilePosts(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView(
      shrinkWrap: true,
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        return Column();
      }).toList());
}

class profileBio extends StatelessWidget {
  const profileBio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 223, 222, 222),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '    Hello',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                      TextSpan(
                        text: " User",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                      TextSpan(
                        text: ',',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '    Email: ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text:
                            '${Provider.of<Authentication>(context, listen: false).getUser()?.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '    Unique Id: ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text:
                            '${Provider.of<Authentication>(context, listen: false).getUser()?.uid}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "To maintain your anonymity we provide you with this Unique Id.",
                    style: TextStyle(fontSize: 8, color: Colors.black38),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            height: 5,
            color: Colors.black54,
          ),
        ),
        Text(
          "Your Recent Posts..",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}

// Future name(BuildContext context, String uid) async {
//   DatabaseEvent event = await userRef.once();
//   dynamic data = event.snapshot.value;
//   return userRef.orderByKey().equalTo(uid).once();
//   // return data.key;
// }

// Future<FirebaseList?> name(BuildContext context, String uid) async {
//   query:
//   userRef;
//   itemBuilder:
//   (context, DataSnapshot snapshot) async {
//     return await Text('${userRef.orderByKey().equalTo(uid).once()}');
//   };
//   return null;
// }
