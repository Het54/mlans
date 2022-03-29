// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/landing_page/landingHelpers.dart';
import '../services/Authentication.dart';
import '../services/FirebaseOperations.dart';
import '../utils/PostOptions.dart';

class FeedHelpers with ChangeNotifier {
  TextEditingController debtController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  uploadPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Divider(
                          thickness: 4.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: debtController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter the debt amount...",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            width: 400,
                            child: TextFormField(
                              controller: contentController,
                              minLines: 10,
                              maxLines: 200,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter the steps...",
                              ),
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          ElevatedButton(
                            onPressed: () async {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadPostData(
                                      "${debtController.text}+${Timestamp.now()}",
                                      {
                                    'debt': debtController.text,
                                    'content': contentController.text,
                                    'userId': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUser()
                                        ?.uid,
                                    'time': Timestamp.now(),
                                    'userEmail': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUser()
                                        ?.email,
                                  }).whenComplete(() {
                                Provider.of<LandingHelpers>(context,
                                        listen: false)
                                    .displayToast(
                                        "Post uploaded successfully!", context);
                                Navigator.pop(context);
                                debtController.clear();
                                contentController.clear();
                              });
                            },
                            child: Row(
                              children: const [
                                Icon(FontAwesomeIcons.share, size: 12),
                                SizedBox(width: 5),
                                Text("Share")
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Container(
          child: RefreshIndicator(
            onRefresh: () {
              return Future(() => null);
            },
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(child: loadPosts(context, snapshot));
                }
              },
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.82,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 223, 222, 222),
                borderRadius: BorderRadius.circular(15),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 209, 209, 209),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 209, 209, 209),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "    ${data['userId']}",
                          style: TextStyle(
                            color: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUser()
                                        ?.uid ==
                                    data['userId']
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUser()
                                        ?.uid ==
                                    data['userId']
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Provider.of<Authentication>(context, listen: false)
                                    .getUser()
                                    ?.uid ==
                                data['userId']
                            ? GestureDetector(
                                child: Icon(EvaIcons.moreVertical),
                                onTap: () {})
                            : Container(height: 0, width: 0),
                      ],
                    ),
                  ),
                  Container(
                      height: 5, color: Color.fromARGB(255, 209, 209, 209)),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Container(
                      child: Text(
                        "₹${data['debt']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Container(
                      child: Text(
                        data['content'],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<PostOptions>(context, listen: false)
                                    .addUpvote(
                                        context,
                                        "${data['debt']}+${data['time']}",
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUser()!
                                            .uid);
                              },
                              child: Icon(
                                FontAwesomeIcons.angleUp,
                                color: Colors.green,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc("${data['debt']}+${data['time']}")
                                  .collection('upvotes')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1)));
                                } else {
                                  return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(color: Colors.green));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<PostOptions>(context, listen: false)
                                    .addDownvote(
                                        context,
                                        "${data['debt']}+${data['time']}",
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUser()!
                                            .uid);
                              },
                              child: Icon(
                                FontAwesomeIcons.angleDown,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc("${data['debt']}+${data['time']}")
                                  .collection('downvotes')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1),
                                  ));
                                } else {
                                  return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(color: Colors.red));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                addCommentSheet(
                                    context,
                                    documentSnapshot,
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUser()!
                                        .uid);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.blue,
                                size: 22,
                              ),
                            ),
                            Text(" 0"),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
        ],
      );
    }).toList());
  }

  addCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    TextEditingController commentController = TextEditingController();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Comments..",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data()! as Map<String, dynamic>;

                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data['userId'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUser()
                                                      ?.uid ==
                                                  data['userId']
                                              ? GestureDetector(
                                                  child: Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: Colors.red,
                                                    size: 2,
                                                  ),
                                                  onTap: () {})
                                              : SizedBox(height: 0, width: 0),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.blue,
                                            size: 12,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(data['comments']))
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          width: 300,
                          height: 20,
                          child: TextField(
                            controller: commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration:
                                InputDecoration(hintText: "Add comment..."),
                          ),
                        )),
                        FloatingActionButton(
                          onPressed: () {
                            // Provider.of<PostOptions>(context, listen: false)
                            //     .addComment(
                            //         context,
                            //         "${snapshot.data()!['debt']}+${snapshot.data()!['time']}",
                            //         commentController.text);
                          },
                          child: Icon(FontAwesomeIcons.commentDots),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
