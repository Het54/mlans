import 'dart:math';
import 'dart:ui';
import 'package:Moneylans/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController linkController = TextEditingController();
TextEditingController imagelinkController = TextEditingController();
TextEditingController appreciateLinkController = TextEditingController();

int activeTag = 0;
List items = ["All", "Refinance", "Earning", "Loan", "Selling", "Cashback"];

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5.0,
        title: Text(
          "Explore",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: rowTags(context),
              ),
              Container(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  onRefresh: () {
                    return Future(() => Future.delayed(Duration(seconds: 1)));
                  },
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Explore')
                        .orderBy('postPoints', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return loadPosts(context, snapshot);
                      }
                    },
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.77,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          uploadPostSheet(context);
        },
      ),
    );
  }

  rowTags(BuildContext context) {
    return Container(
      height: 35,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) => Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTag = index;
                });
              },
              child: Container(
                width: 100,
                child: Center(
                    child: Text(
                      "${items[index]}",
                      style: TextStyle(color: Colors.black),
                    )), //Color(0xFFFF2323)
                decoration: BoxDecoration(
                    color:
                    activeTag == index ? Color(0xffd9d9d9) : Colors.white,
                    border: Border.all(
                        width: 1.5,
                        color: activeTag == index
                            ? Colors.white
                            : Color(0xffd9d9d9)),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

 TextEditingController report= TextEditingController();

  loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
          List upvote;
          List downvote;
          List postTags = data["tags"];
          String? userId =
              Provider.of<Authentication>(context, listen: false).getUser()?.uid;
          upvote = data['upvotes'];
          downvote = data['downvotes'];
          return data["Accepted"] &&
              (postTags.contains(items[activeTag]) || activeTag == 0)
              ? Container(
            child: Padding(
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
                      padding: EdgeInsets.only(left: 22, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.lightBlue,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                      title: Text("Report"),
                                      content: TextFormField(
                                        autofocus: true,
                                        controller: report,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            // Provider.of<FirebaseOperations>(
                                            //     context,
                                            //     listen: false)
                                            //     .reportComment(
                                            //     "${Provider.of<Authentication>(context, listen: false).getUser()?.uid}",
                                            //     "${data["postId"]},${data["data"]}",
                                            //     {
                                            //       "user": 1,
                                            //       "report":
                                            //       report.text
                                            //     });
                                            // Navigator.of(ctx)
                                            //     .pop();
                                            // report.clear();
                                          },
                                          child: Text("SEND"),
                                        ),
                                      ]),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(Icons.more_vert),
                              ))
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data['description'],
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Link :  ',
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data['link'],
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.network(
                                data['imageLink'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                          Row(
                            children: [
                              Text(
                                'Shared by :  ',
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data['sharedBy'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Appreciate by :  ',
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => launchUrl(Uri.parse(
                                    "https://${data["appreciateLink"]}")),
                                child: SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text("Visit"),
                                        SizedBox(width: 10),
                                        Icon(FontAwesomeIcons.share,
                                            size: 12),
                                      ],
                                    )),
                              ),
                            ],
                          ),
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
                            upvote.contains(userId)
                                ? upvote.remove(userId)
                                : upvote.add(userId);
                            FirebaseFirestore.instance
                                .collection('Explore')
                                .doc(data['link'])
                                .update({
                              "upvotes": upvote,
                              "postPoints":
                              max(upvote.length, downvote.length) -
                                  min(upvote.length, downvote.length)
                            });
                          },
                          child: Container(
                              width:
                              MediaQuery.of(context).size.width / 2 - 20,
                              child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.angleUp,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                                    SizedBox(width: 4),
                                    Text("${upvote.length}")
                                  ])),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 2,
                          color: Colors.grey.shade400,
                          indent: 5,
                          endIndent: 5,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            downvote.contains(userId)
                                ? downvote.remove(userId)
                                : downvote.add(userId);
                            FirebaseFirestore.instance
                                .collection('Explore')
                                .doc(data['link'])
                                .update({
                              "downvotes": downvote,
                              "postPoints":
                              max(upvote.length, downvote.length) -
                                  min(upvote.length, downvote.length)
                            });
                          },
                          child: Container(
                              width:
                              MediaQuery.of(context).size.width / 2 - 20,
                              child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.angleDown,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    SizedBox(width: 4),
                                    Text("${downvote.length}")
                                  ])),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox(
            width: 0,
            height: 0,
          );
        }).toList());
  }

  uploadPostSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return mybottomsheet();
      },
    );
  }
}

class mybottomsheet extends StatefulWidget {
  const mybottomsheet({Key? key}) : super(key: key);

  @override
  State<mybottomsheet> createState() => _mybottomsheetState();
}

class _mybottomsheetState extends State<mybottomsheet> {
  List tags = [];
  bool temp = true;
  List items = ["Refinance", "Earning", "Loan", "Selling", "Cashback"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
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
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Title",
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter the title...",
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
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 8,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Description",
                          filled: true,
                          hintText: "Enter the description...",
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 35,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) => Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (tags.contains(items[index]))
                                  tags.remove(items[index]);
                                else
                                  tags.add(items[index]);
                              });
                            },
                            child: Container(
                              width: 100,
                              child: Center(
                                  child: Text(
                                    "${items[index]}",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              decoration: BoxDecoration(
                                  color:
                                  tags.contains(items[index]) ? Color(0xffd9d9d9) : Colors.white,
                                  border: Border.all(
                                      width: 1.5,
                                      color: tags.contains(items[index])
                                          ? Colors.white
                                          : Color(0xffd9d9d9)),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: linkController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Website Link",
                      hintText: "Enter the link...",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: imagelinkController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Website logo Link",
                      hintText: "Enter the link...",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: appreciateLinkController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Affiliate Link",
                      hintText: "Enter your affiliate link...",
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
                          titleController.clear();
                          descriptionController.clear();
                          linkController.clear();
                          imagelinkController.clear();
                          appreciateLinkController.clear();
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            linkController.text.isEmpty ||
                            imagelinkController.text.isEmpty ||
                            appreciateLinkController.text.isEmpty)
                          Fluttertoast.showToast(
                              msg: "Enter proper details!");
                        else if(tags.isEmpty)
                          Fluttertoast.showToast(
                              msg: "Select alteast one tag!");
                        else
                          FirebaseFirestore.instance
                              .collection('Explore')
                              .doc(linkController.text)
                              .set({
                            "Accepted": false,
                            "title": titleController.text,
                            "description": descriptionController.text,
                            "link": linkController.text,
                            "imageLink": imagelinkController.text,
                            "appreciateLink": appreciateLinkController.text,
                            "time": Timestamp.now(),
                            "sharedBy": Provider.of<Authentication>(context,
                                listen: false)
                                .getUser()
                                ?.uid,
                            "tags" : tags,
                            "upvotes": [],
                            "downvotes": [],
                            "postPoints": 0
                          }).then((value) => {
                            titleController.clear(),
                            descriptionController.clear(),
                            linkController.clear(),
                            imagelinkController.clear(),
                            appreciateLinkController.clear(),
                            Fluttertoast.showToast(
                                msg: "Details Submitted\n(It can take 1-3 working days to approve)"),
                            Navigator.pop(context)
                          });
                      },
                      child: Row(
                        children: [
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
  }
}