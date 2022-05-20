// ignore_for_file: unnecessary_brace_in_string_interps, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:Moneylans/screens/debt_meter/DebtMeter.dart';
import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';

class Profile extends StatelessWidget {
  String name;

  Profile({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<Authentication>(context, listen: false).getUser()?.uid;

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
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Provider.of<ProfileHelpers>(context,
                                  listen: false)
                              .customDrawer(context);
                        });
                  },
                  child: Icon(Icons.more_vert, color: Colors.black),
                )),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileBio(name: name),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUser()
                        ?.uid)
                    .collection('posts')
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: GridView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 25,
                                  crossAxisCount: 2),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return profilePostSheet(
                                        context,
                                        data['debt'],
                                        data['content'],
                                      );
                                    });
                              },
                              onLongPress: () => deleteDialog(context, data),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 223, 222, 222),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15)),
                                      ),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Debt:",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () => deleteDialog(context, data),
                                              child: Icon(EvaIcons.moreVertical,
                                                  size: 25),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 35),
                                    Text(
                                      "₹${data['debt']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }

  Future<dynamic> deleteDialog(
      BuildContext context, Map<String, dynamic> data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white),
              child: TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUser()
                            ?.uid)
                        .collection('posts')
                        .doc(
                            "${data['debt']}+${data['time'].toString().substring(18, 28)}")
                        .delete();
                    Navigator.pop(context);
                  },
                  child: Text("Delete post history")),
            ),
          );
        });
  }
}

profilePostSheet(BuildContext context, String debt, String content) {
  return Dialog(
    backgroundColor: Colors.transparent,
    child: Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Debt : "),
                      Text("₹${debt}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Divider(
                    height: 5,
                    color: Colors.black54,
                  ),
                ),
                Text(content),
                SizedBox(height: 4,)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class profileBio extends StatelessWidget {
  String name;

  profileBio({
    Key? key,
    required this.name,
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userData')
                            .doc(
                            "${Provider.of<Authentication>(context, listen: false).getUser()?.uid}")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(snapshot.data!.get('name'),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 20));
                          }
                        },
                      ),
                      Text(",",style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
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
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/home-finance-picture-id1295832050?b=1&k=20&m=1295832050&s=170667a&w=0&h=6OQrn4tjqB7QIlDSmCt5Jof3187Iyk-jRMV_qlidROQ="),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.4)),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Check your debt-o-score!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => DebtMeter())));
                      },
                      child: Text("Check now!",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      )),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            height: 5,
            color: Colors.black54,
          ),
        ),
        Text(
          "Your Post History...",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
