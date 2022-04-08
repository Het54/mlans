// ignore_for_file: prefer_const_constructors, void_checks

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import '../../utils/PostOptions.dart';
import '../landing_page/landingHelpers.dart';

class FeedHelpers with ChangeNotifier {
  TextEditingController debtController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  uploadPostSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                    "${debtController.text}+${Timestamp.now().toString().substring(18, 28)}",
                                    {
                                  'debt': debtController.text,
                                  'content': contentController.text,
                                  'userId': Provider.of<Authentication>(context,
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
                            }).whenComplete(() {
                              return FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUser()
                                      ?.uid)
                                  .collection('posts')
                                  .add({
                                'debt': debtController.text,
                                'content': contentController.text,
                                'userId': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUser()
                                    ?.uid,
                                'time': Timestamp.now(),
                                'userEmail': Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                    .getUser()
                                    ?.email,
                              });
                            }).whenComplete(() {
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
      },
    );
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
                  .orderBy('time', descending: true)
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
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        editDeletePostDialog(
                                      context,
                                      data['debt'],
                                      data['content'],
                                      "${data['debt']}+${data['time'].toString().substring(18, 28)}",
                                    ),
                                  );
                                },
                              )
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
                                        "${data['debt']}+${data['time'].toString().substring(18, 28)}",
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
                                  .doc(
                                      "${data['debt']}+${data['time'].toString().substring(18, 28)}")
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
                                        "${data['debt']}+${data['time'].toString().substring(18, 28)}",
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
                                  .doc(
                                      "${data['debt']}+${data['time'].toString().substring(18, 28)}")
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
                                        .uid,
                                    "${data['debt']}+${data['time'].toString().substring(18, 28)}");
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.blue,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(
                                      "${data['debt']}+${data['time'].toString().substring(18, 28)}")
                                  .collection('comments')
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
                                    " ${snapshot.data!.docs.length.toString()}",
                                    style: TextStyle(color: Colors.blue),
                                  );
                                }
                              },
                            ),
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

  addCommentSheet(BuildContext context, DocumentSnapshot snapshot, String docId,
      String postId) {
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
                        thickness: 4.0,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Comments..",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('time', descending: true)
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        data['userId'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUser()
                                                      ?.uid ==
                                                  data['userId']
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.blue,
                                            size: 12,
                                          ),
                                          SizedBox(width: 2),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 300,
                            height: 20,
                            child: TextField(
                              controller: commentController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration:
                                  InputDecoration(hintText: "Add comment..."),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Provider.of<PostOptions>(context, listen: false)
                                .addComment(
                                    context, postId, commentController.text);
                            commentController.clear();
                          },
                          child: Icon(FontAwesomeIcons.telegramPlane),
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

  editDeletePostDialog(
      BuildContext context, String debt, String content, String postId) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.215,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(children: [
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                editPostSheet(context, debt, content, postId);
              },
              child: Text("Edit Steps"),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Provider.of<PostOptions>(context, listen: false)
                    .deletePost(context, postId)
                    .whenComplete(() {
                  Provider.of<LandingHelpers>(context, listen: false)
                      .displayToast("Post deleted successfully!", context);
                  Navigator.pop(context);
                });
              },
              child: Text("Delete post"),
            ),
          ),
          SizedBox(height: 0),
        ]),
      ),
    );
  }

  editPostSheet(
      BuildContext context, String debt, String content, String postId) {
    TextEditingController debtControl = TextEditingController();
    debtControl.text = debt;
    TextEditingController contentControl = TextEditingController();
    contentControl.text = "${content}";

    return showModalBottomSheet(
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
                          controller: debtControl,
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
                            controller: contentControl,
                            minLines: 10,
                            maxLines: 200,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter the steps...",
                            ),
                          ),
                        ),
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
                                  .updatePostData(postId, {
                                'content': contentControl.text,
                              }).whenComplete(() {
                                Provider.of<LandingHelpers>(context,
                                        listen: false)
                                    .displayToast(
                                        "Post uploaded successfully!", context);
                              }).whenComplete(() {
                                Navigator.pop(context);
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

  premiumBanner(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      Provider.of<LandingHelpers>(context, listen: false)
                          .displayToast("Coming soon..!", context);
                    },
                    child: Text("Try")),
              ),
              Text("  Premium for free!",
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          Text("Just answer a few questions and become our premium member!",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 8,
              ))
        ],
      ),
    );
  }
}
