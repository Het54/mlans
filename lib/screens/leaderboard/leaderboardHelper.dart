import 'dart:convert';
import 'package:Moneylans/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../services/FirebaseOperations.dart';
import '../../utils/PostOptions.dart';

int userIndex = 0, userPoint = 0;
List l = [];
bool? check = false;
String? userlink;

class firebaseTopList extends StatefulWidget {
  String? userId;

  firebaseTopList({Key? key, this.userId}) : super(key: key);

  @override
  State<firebaseTopList> createState() => _firebaseTopListState();
}

class _firebaseTopListState extends State<firebaseTopList> {

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection("leaderboard")
    .doc(this.widget.userId)
    .get()
    .then((value) => {
      print(value["index"]),
        if (userlink == "" || userlink == null) 
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if(value["index"]<11){
              await showCustomDialog(context, widget.userId.toString());
            }
        })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy("point", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("assets/images/leadBg.jpg"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: leaderList(context, snapshot, widget.userId)),
                ),
                Divider(
                  color: Colors.yellow,
                  height: 1,
                ),
                winnerNameTemplate(userId: widget.userId)
              ],
            );
          }
        },
      ),
    );
  }
}

TextEditingController product = TextEditingController();
TextEditingController desc = TextEditingController();
TextEditingController link = TextEditingController();

showCustomDialog(BuildContext context, String userId) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Enter Details",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                            product.clear();
                            desc.clear();
                            link.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius:
                                  MediaQuery.of(context).size.height * 0.015,
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    EnterDetailsEnteryBox(
                        Boxtext: "Enter Product/Service Name", sText: " "),
                    SizedBox(height: 15),
                    EnterDetailsEnteryBox(
                        Boxtext: "Enter Description", sText: "Your Story"),
                    SizedBox(height: 15),
                    EnterDetailsEnteryBox(
                        Boxtext: "Enter Link", sText: "www.affiliate.com"),
                    SizedBox(height: 15),
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () {
                            if (desc.text.isNotEmpty && link.text.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("leaderboard")
                                  .doc(userId)
                                  .update({
                                "Product": product.text,
                                "description": desc.text,
                                "link": link.text,
                              }).then((value) => {
                                        if (userIndex == 1)
                                          FirebaseFirestore.instance
                                              .collection("leaderboardDetails")
                                              .doc("Detail")
                                              .update({
                                            "Product": product.text,
                                            "Description": desc.text,
                                            "Link": link.text,
                                            "userId": userId
                                          })
                                      });
                              Fluttertoast.showToast(msg: "Data Updated!");
                              product.clear();
                              desc.clear();
                              link.clear();
                              Navigator.pop(context, true);
                            } else
                              Fluttertoast.showToast(
                                  msg: "Enter Valid Details!");
                          },
                          child: SizedBox(
                              height: 25,
                              child: Center(child: Text("Submit")))),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

class EnterDetailsEnteryBox extends StatelessWidget {
  String? Boxtext;
  String? sText;

  EnterDetailsEnteryBox({Key? key, this.Boxtext, this.sText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: sText == " "
            ? 30
            : sText == "Your Story"
                ? 300
                : null,
        maxLines: sText == "Your Story" ? 3 : 1,
        controller: sText == " "
            ? product
            : sText == "Your Story"
                ? desc
                : link,
        decoration: new InputDecoration(
          labelText: Boxtext,
          hintText: sText,
          labelStyle: TextStyle(color: Colors.black),
          focusColor: Colors.black,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
          //fillColor: Colors.green
        ),
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontFamily: "Poppins",
        ));
  }
}

class winnerNameTemplate extends StatelessWidget {
  final String? userId;

  winnerNameTemplate({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: userIndex == 1
          ? Color(0xE6FFCC00)
          : userIndex == 2
              ? Color(0xE68FFFFF)
              : userIndex == 3
                  ? Color(0xE6F68FFD)
                  : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text("${userIndex}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
          Container(
            child: Text("You",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ),
          Expanded(child: SizedBox()),
          Text("${userPoint}",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400)),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                ),
                onPressed: () => showCustomDialog(context, userId!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

launchurl(url) async {
  if (await canLaunchUrl(Uri.parse(url)))
    await launchUrl(Uri.parse(url));
  else
    throw "Could not launch $url";
}

customDrawer(BuildContext context, userId, description, link, userPoints, index, product) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            /*height: MediaQuery
                .of(context)
                .size
                .height * 0.3,*/
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left:185),
                              child:   GestureDetector(
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
                                    child: Icon(Icons.more_vert,color: Colors.white,),
                                  ))

                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12, left: 12, top: 2, bottom: 10),
                            child: link != null && link != ""
                                ? Text("This week's $index rank holders get help from $product, try by clicking on the visit",
                                style: TextStyle(color: Colors.white))
                                : Text("No data updated!",
                                    style: TextStyle(color: Colors.white)),
                          ),

                          link != "" && link != null
                              ? ElevatedButton(
                                  onPressed: () => launchurl("https://${link}"),
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
                                )
                              : SizedBox(height: 0, width: 0),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12, left: 12, top: 20, bottom: 10),
                            child: link != null && link != ""
                                ? Text("Total Points: $userPoints",
                                    style: TextStyle(color: Colors.white))
                                : SizedBox(height: 0, width: 0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12, left: 12, top: 0, bottom: 10),
                            child: link != null && link != ""
                                ? Text("Description: $description",
                                    style: TextStyle(color: Colors.white))
                                : SizedBox(height: 0, width: 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            feedBody(context, userId, userPoints),
                      ),
                    );
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          "View Strategies",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              wordSpacing: 5),
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      });
}

Widget feedBody(BuildContext context, userId, userPoints) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        title: Text(
          userId,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
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
                    return userPoints > 0
                        ? loadPosts(context, snapshot, userId)
                        : Center(
                            child: Text(
                            "No Posts Available",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ));
                  }
                },
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    ),
  );
}

sendNotification(String title, String token) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAADLBdq2Y:APA91bHH0thNUfQqZnQBnb0mqU3VnJG9sz4uGBLeBZEaB1NZUE6BASB2FJMekDnZPPMmijQY6yB4gFlFaL2-SzmBF364khQiMzA9x3keE5YrHY_cYR_Eu3_WO6bCVqkLpePNmCGJ70kG'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'body': 'You have received $title'
              },
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Notificatin sent");
    } else {
      print("Error");
    }
  } catch (e) {}
}

checkpointer(String postid, String type) async {
  await FirebaseFirestore.instance
      .collection("posts")
      .doc(postid)
      .collection("$type")
      .get()
      .then((docSnapshot) => {
            for (int i = 0; i < docSnapshot.docs.length; i++)
              {l.add(docSnapshot.docs[i].data()['userId'])}
          });

  for (int i = 0; i < l.length; i++) {
    if (l[i] == FirebaseAuth.instance.currentUser?.uid) {
      check = true;
    }
  }
  l.clear();
  return (check);
}
TextEditingController report= TextEditingController();
Widget loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, userId) {
  return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    return userId == data['userId']
        ? Padding(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${data['userId']}",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
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
                data['postType'] == 1
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xffd9d9d9)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Debt:  ',
                                              style: TextStyle(fontSize: 16)),
                                          TextSpan(
                                            text: "₹${data['debt']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                thickness: 1,
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
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xffd9d9d9)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  data['title'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                thickness: 1,
                                color: Color(0xff636363),
                              ),
                              Text(
                                data['content'],
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black,
                                ),
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
                        onTap: () async {
                          check = await checkpointer(data['postId'], "upvotes");
                          if (check == false) {
                            FirebaseFirestore.instance
                                .collection("userData")
                                .doc(data['userId'])
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                print(
                                    'Document data: ${documentSnapshot.data()}');
                                var a = documentSnapshot.data();
                                Map.from(a as Map<String, dynamic>);
                                String token = a["token"];
                                sendNotification("Upvote", token);
                              }
                            });
                            Provider.of<PostOptions>(context, listen: false)
                                .addUpvote(
                                    context,
                                    data['postId'],
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUser()!
                                        .uid,
                                    data['userId']);
                          }
                          check = false;
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4 - 10,
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
                                    .doc(data['postId'])
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
                        onTap: () async {
                          check =
                              await checkpointer(data['postId'], "downvotes");
                          if (check == false) {
                            FirebaseFirestore.instance
                                .collection("userData")
                                .doc(data['userId'])
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                print(
                                    'Document data: ${documentSnapshot.data()}');
                                var a = documentSnapshot.data();
                                Map.from(a as Map<String, dynamic>);
                                String token = a["token"];
                                print(token);
                                sendNotification("Downvote", token);
                              }
                            });
                            Provider.of<PostOptions>(context, listen: false)
                                .addDownvote(
                                    context,
                                    data['postId'],
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUser()!
                                        .uid,
                                    data['userId']);
                          }
                          check = false;
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4 - 10,
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
                                    .doc(data['postId'])
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
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          addCommentSheet(
                              context,
                              documentSnapshot,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUser()!
                                  .uid,
                              data['postId'],
                              data['userId']);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4 - 10,
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
                                    .doc(data['postId'])
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
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Share.share(
                          data['content'],
                          subject: data['debtType'] +
                              " at " +
                              data['intrestPercentage'] +
                              "% interest" +
                              " for " +
                              data['timePeriod'],
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4 - 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.shareAlt,
                                color: Colors.blue,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }).toList());
}

addCommentSheet(BuildContext context, DocumentSnapshot snapshot, String docId,
    String postId, String userId) {
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;

                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.11,
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
                      SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("userData")
                              .doc(userId)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              print(
                                  'Document data: ${documentSnapshot.data()}');
                              var a = documentSnapshot.data();
                              Map.from(a as Map<String, dynamic>);
                              String token = a["token"];
                              print(token);
                              sendNotification("Comment", token);
                            }
                          });
                          Provider.of<PostOptions>(context, listen: false)
                              .addComment(context, postId,
                                  commentController.text, userId);
                          commentController.clear();
                        },
                        child: Transform.rotate(
                            angle: 100,
                            child: Icon(Icons.send, color: Colors.white)),
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

Widget leaderList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, userId) {
  int index = 0;
  return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
        index++;
        FirebaseFirestore.instance
          .collection("leaderboard")
          .doc(data["userId"])
          .set({'index': index}, SetOptions(merge: true));
        if (data["userId"] == userId) {
          userIndex = index;
          userPoint = data["point"] * 10;
        };
        return Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 5, bottom: 5),
          child: GestureDetector(
            onTap: () =>
                customDrawer(context, data["userId"], data["description"], data["link"], data["point"] * 10, data["index"], data["Product"]),
            child: Container(
              decoration: BoxDecoration(
                  color: index == 1
                      ? Color(0xB3FFCC00)
                      : index == 2
                      ? Color(0xB38FFFFF)
                      : index == 3
                          ? Color(0xB3F68FFD)
                          : Colors.black12,
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 15),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text("${index}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: index == 1
                                ? FontWeight.w600
                                : index == 2
                                    ? FontWeight.w400
                                    : index == 3
                                        ? FontWeight.w300
                                        : FontWeight.w200)),
                  ),
                ),
              ),
              Container(
                width: 250,
                child: Text(data["userId"] == userId ? "You" : data["userId"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: index == 1
                            ? FontWeight.w600
                            : index == 2
                                ? FontWeight.w400
                                : index == 3
                                    ? FontWeight.w300
                                    : FontWeight.w200)),
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text("${data["point"] * 10}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: index == 1
                                ? FontWeight.w600
                                : index == 2
                                    ? FontWeight.w400
                                    : index == 3
                                        ? FontWeight.w300
                                        : FontWeight.w200)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }).toList());
}
