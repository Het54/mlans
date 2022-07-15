import 'package:Moneylans/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

int userIndex = 0,
    userPoint = 0;

class leaderboardHelper with ChangeNotifier {
  Widget firebaseTopList(BuildContext context, userId) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
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
                      child: leaderList(context, snapshot, userId)),
                ),
                Divider(
                  color: Colors.yellow,
                  height: 1,
                ),
                winnerNameTemplate(userId: userId)
              ],
            );
          }
        },
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String userId) {
  TextEditingController desc = TextEditingController();
  TextEditingController link = TextEditingController();
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
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
            height: MediaQuery
                .of(context)
                .size
                .height * 0.5,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                      controller: desc,
                      decoration: new InputDecoration(
                        labelText: "Enter Description",
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "Your Story",
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
                      maxLength: 300,
                      maxLines: 4,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      )),
                  TextFormField(
                      controller: link,
                      decoration: new InputDecoration(
                        labelText: "Enter Link",
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "www.affiliate.com",
                        focusColor: Colors.black,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        //fillColor: Colors.green
                      ),
                      maxLines: 1,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.url,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      )),
                  SizedBox(height: 15),
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () {
                            if (desc.text.isNotEmpty && link.text.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("leaderboard")
                                  .doc(userId)
                                  .update({
                                "description": desc.text,
                                "link": link.text,
                              }).then((value) =>
                              {
                                if (userIndex == 1)
                                  FirebaseFirestore.instance
                                      .collection("leaderboardDetails")
                                      .doc("Detail")
                                      .update({
                                    "Description": desc.text,
                                    "Link": link.text,
                                    "userId": userId
                                  })
                              });
                              Fluttertoast.showToast(msg: "Data Updated!");
                              Navigator.pop(context, true);
                            } else
                              Fluttertoast.showToast(
                                  msg: "Enter Valid Details!");
                        },
                        child: SizedBox(
                            height: 25, child: Center(child: Text("Submit")))),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

class winnerNameTemplate extends StatelessWidget {
  String? userId;

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

launchUrl(url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw "Could not launch $url";
}

customDrawer(BuildContext context, userId, description, link, userPoints) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            /*height: MediaQuery
                .of(context)
                .size
                .height * 0.3,*/
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
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
                            padding: const EdgeInsets.only(
                                right: 12, left: 12, top: 20, bottom: 10),
                            child: description != null && description != ""
                                ? Text(description,
                                style: TextStyle(color: Colors.white))
                                : Text("No data updated!",
                                style: TextStyle(color: Colors.white)),
                          ),
                          link != "" && link != null
                              ? ElevatedButton(
                            onPressed: () => launchUrl("https://${link}"),
                            child: SizedBox(
                                width: 100,
                                height: 25,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Visit"),
                                    SizedBox(width: 10),
                                    Icon(FontAwesomeIcons.share, size: 12),
                                  ],
                                )),
                          )
                              : SizedBox(height: 0, width: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => feedBody(context,userId,userPoints),
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
                        child: Text("View Strategies",
                          style: TextStyle(color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            wordSpacing: 5
                          ),
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        );
      });
}

Widget feedBody(BuildContext context,userId,userPoints) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        title: Text(userId,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16
            ),
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
                    return userPoints > 0 ?
                        loadPosts(context, snapshot,userId)
                           : Center(child: Text("No Posts Available",style: TextStyle(fontSize: 18,color: Colors.black),));
                  }
                },
              ),
            ),
            height: MediaQuery.of(context).size.height ,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    ),
  );
}

Widget loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,userId) {
  return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
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
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              data['postType'] == 1
                  ? Container(
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
                        height: MediaQuery.of(context).size.height * 0.02,
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
                  border: Border.all(width: 2, color: Color(0xffd9d9d9)),
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
                        height: MediaQuery.of(context).size.height * 0.02,
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

              GestureDetector(
                onTap:() => Fluttertoast.showToast(msg: "Can't perform here"),
                child: Container(
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
                      Container(
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
                      Container(
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
                      Container(
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
              : SizedBox();
      }).toList());
}

Widget leaderList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
    userId) {
  int index = 0;
  return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
        index++;
        if (data["userId"] == userId) {
          userIndex = index;
          userPoint = data["point"] * 10;
        };
        return Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 5, bottom: 5),
          child: GestureDetector(
            onTap: () =>
                customDrawer(context, data["userId"], data["description"], data["link"], data["point"] * 10),
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                    child: Text(
                        data["userId"] == userId ? "You" : data["userId"],
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
