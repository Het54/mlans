// ignore_for_file: prefer_const_constructors, void_checks

import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import '../../utils/PostOptions.dart';
import '../feedback_question/Feedback.dart';
import '../landing_page/landingHelpers.dart';

class FeedHelpers with ChangeNotifier {
  TextEditingController debtController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController intrestController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int currentTextLength = 0;
  int i = 1;

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
              height: MediaQuery.of(context).size.height * 0.842,
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
                          labelText: "Debt amount",
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter the debt amount...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: intrestController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Interest Percentage",
                          filled: true,
                          hintText: "Enter the interest percentage...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: typeController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Type",
                          hintText: "Enter the debt type...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: tenureController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Tenure",
                          hintText: "Enter the time period of debt...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: goalController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Payoff Goal Date",
                          hintText: "Enter the goal date...",
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
                            onChanged: (String newText) {
                              if (newText[0] != 'S') {
                                newText = 'Step $i • ' + newText;
                                contentController.text = newText;
                                contentController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: contentController.text.length));
                              }
                              if (newText[newText.length - 1] == '\n' &&
                                  newText.length > currentTextLength) {
                                i += 1;
                                contentController.text = newText + 'Step $i • ';
                                contentController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: contentController.text.length));
                              }
                              currentTextLength = contentController.text.length;
                            },
                            controller: contentController,
                            minLines: 8,
                            maxLines: 200,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: "Steps",
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
                              i = 1;
                              debtController.clear();
                              intrestController.clear();
                              tenureController.clear();
                              typeController.clear();
                              contentController.clear();
                              goalController.clear();
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
                                      'postId' : "${debtController.text}+${Timestamp.now().toString().substring(18, 28)}",
                                      'edited': false,
                                      'debt': debtController.text,
                                      'intrestPercentage': intrestController.text,
                                      'debtType': typeController.text,
                                      'timePeriod': tenureController.text,
                                      'goalDate': goalController.text,
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
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadPostDataInProfile(
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUser()!
                                          .uid,
                                      "${debtController.text}+${Timestamp.now().toString().substring(18, 28)}",
                                      {
                                    'edited': false,
                                    'debt': debtController.text,
                                    'intrestPercentage': intrestController.text,
                                    'debtType': typeController.text,
                                    'timePeriod': tenureController.text,
                                    'goalDate': goalController.text,
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
                                  });
                            }).whenComplete(() {
                              Navigator.pop(context);
                              debtController.clear();
                              intrestController.clear();
                              tenureController.clear();
                              typeController.clear();
                              contentController.clear();
                              goalController.clear();
                              i = 1;
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
            backgroundColor: Colors.transparent,
            color: Colors.black,
            onRefresh: () {
              return Future(() => Future.delayed(Duration(seconds: 1)));
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
    TextEditingController reportController = TextEditingController();
    return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Color(0xffd9d9d9),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data['userId']}",
                      style: TextStyle(
                        color:
                            Provider.of<Authentication>(context, listen: false)
                                        .getUser()
                                        ?.uid ==
                                    data['userId']
                                ? Colors.blue
                                : Colors.black,
                        fontWeight:
                            Provider.of<Authentication>(context, listen: false)
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
                                  data['debtType'],
                                  data['goalDate'],
                                  data['intrestPercentage'],
                                  data['timePeriod'],
                                  data['postId'],
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Report"),
                              content: TextFormField(
                                autofocus: true,
                                controller: reportController,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                        .reportPost(
                                        "${Provider.of<Authentication>(context, listen: false)
                                            .getUser()
                                            ?.uid}",
                                        "${data["debt"]}+${data["time"].seconds}",
                                        {
                                          "user" : 1,
                                          "report" : reportController.text
                                        });
                                    Navigator.of(ctx).pop();
                                    reportController.clear();
                                  },
                                  child: Text("okay"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(EvaIcons.moreVertical)
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xffd9d9d9)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Debt:  ',
                                    style: TextStyle(fontSize: 16)),
                                TextSpan(
                                  text: "₹${data['debt']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Target:  ',
                                    style: TextStyle(fontSize: 16)),
                                TextSpan(
                                  text: "${data['goalDate']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['debtType'] +
                          " at " +
                          data['intrestPercentage'] +
                          "% interest" +
                          " for " +
                          data['timePeriod'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Color(0xff636363),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        data['content'],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 1),
                    data['edited']
                        ? Row(
                            children: [
                              Text(
                                "(Edited)",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(width: 0)
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Color(0xffd9d9d9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Provider.of<PostOptions>(context, listen: false).addUpvote(
                          context,
                          "${data['debt']}+${data['time'].toString().substring(18, 28)}",
                          Provider.of<Authentication>(context, listen: false)
                              .getUser()!
                              .uid);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.angleUp,
                            color: Colors.green,
                            size: 22,
                          ),
                          SizedBox(width: 4),
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
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Provider.of<PostOptions>(context, listen: false).addDownvote(
                          context,
                          "${data['debt']}+${data['time'].toString().substring(18, 28)}",
                          Provider.of<Authentication>(context, listen: false)
                              .getUser()!
                              .uid);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.angleDown,
                            color: Colors.red,
                            size: 22,
                          ),
                          SizedBox(width: 4),
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
                                  child:
                                      CircularProgressIndicator(strokeWidth: 1),
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
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      addCommentSheet(
                          context,
                          documentSnapshot,
                          Provider.of<Authentication>(context, listen: false)
                              .getUser()!
                              .uid,
                          "${data['debt']}+${data['time'].toString().substring(18, 28)}");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.comment,
                            color: Colors.blue,
                            size: 22,
                          ),
                          SizedBox(width: 4),
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
                                  child:
                                      CircularProgressIndicator(strokeWidth: 1),
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
                    ),
                  )
                ],
              ),
            )
          ],
        ),
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
                          child: Dialog(
                            child: Container(),
                          ),
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
      BuildContext context, String debt, String content, String debtType, String goalDate, String interestPercentage, String timePeriod, String postId) {
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
                editPostSheet(context, debt, content, debtType, goalDate, interestPercentage, timePeriod, postId);
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
      BuildContext context, String debt, String content, String debtType, String goalDate, String interestPercentage, String timePeriod, String postId) {
    TextEditingController debtControl = TextEditingController();
    TextEditingController contentControl = TextEditingController();
    TextEditingController debtTypeControl = TextEditingController();
    TextEditingController goalDateControl = TextEditingController();
    TextEditingController interestPercentageControl = TextEditingController();
    TextEditingController timePeriodControl = TextEditingController();
    debtControl.text = debt;
    contentControl.text = "${content}";
    debtTypeControl.text = "${debtType}";
    goalDateControl.text = "${goalDate}";
    interestPercentageControl.text = "${interestPercentage}";
    timePeriodControl.text = "${timePeriod}";

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
              height: MediaQuery.of(context).size.height * 0.842,
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
                          labelText: "Debt amount",
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter the debt amount...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: interestPercentageControl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Interest Percentage",
                          filled: true,
                          hintText: "Enter the interest percentage...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: debtTypeControl,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Type",
                          hintText: "Enter the debt type...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: timePeriodControl,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Tenure",
                          hintText: "Enter the time period of debt...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: goalDateControl,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Debt Payoff Goal Date",
                          hintText: "Enter the goal date...",
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
                            labelText: "Steps",
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
                                backgroundColor: MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        ElevatedButton(
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                listen: false)
                                .updatePostData(postId, {
                              'debt': debtControl.text,
                              'intrestPercentage': interestPercentageControl.text,
                              'debtType': debtTypeControl.text,
                              'timePeriod': timePeriodControl.text,
                              'goalDate': goalDateControl.text,
                              'content': contentControl.text,
                              'edited': true
                            }).whenComplete(() {
                              Provider.of<LandingHelpers>(context,
                                  listen: false)
                                  .displayToast(
                                  "Post updated successfully!", context);
                            }).whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              debtControl.clear();
                              interestPercentageControl.clear();
                              debtTypeControl.clear();
                              timePeriodControl.clear();
                              goalDateControl.clear();
                              contentControl.clear();
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
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )
      /*showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
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
                            labelText: "Debt Amount",
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
                              labelText: "Steps",
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
                                'edited': true
                              }).whenComplete(() {
                                Provider.of<LandingHelpers>(context,
                                        listen: false)
                                    .displayToast(
                                        "Post updated successfully!", context);
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
        })*/;
  }

  premiumBanner(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width,
      color: Colors.blue,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Feedbacck(),
                          ),
                        );
                      },
                      child: Text("Try")),
                ),
                Text("  Premium for free!",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            Text(
              "Just answer a few questions and become our premium member!",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 8,
              ),
            ),
            Text(
              "And get a chance to access a lot more features!",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
