// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:Moneylans/screens/leaderboard/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import 'FeedHelpers.dart';

TextEditingController debtController = TextEditingController();
TextEditingController tenureController = TextEditingController();
TextEditingController goalController = TextEditingController();
TextEditingController intrestController = TextEditingController();
TextEditingController typeController = TextEditingController();
TextEditingController contentController = TextEditingController();
int currentTextLength = 0;
int StategycurrentTextLength = 0;
int i = 1;
List l = [];
List m = [];
bool? check = false;
int activatedTag = 0;

class Feed extends StatelessWidget {
  Feed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          postOption(context);
        },
      ),
      body: feedHelper(),
    );
  }
}

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
                          debtController.text.isNotEmpty &&
                              intrestController.text.isNotEmpty &&
                              typeController.text.isNotEmpty &&
                              tenureController.text.isNotEmpty &&
                              goalController.text.isNotEmpty &&
                              contentController.text.isNotEmpty
                              ? Provider.of<FirebaseOperations>(context,
                              listen: false)
                              .uploadPostData(
                              "${debtController.text}+${Timestamp.now().toString().substring(18, 28)}",
                              {
                                'postType': 1,
                                'postId':
                                "${debtController.text}+${Timestamp.now().toString().substring(18, 28)}",
                                'edited': false,
                                'debt': debtController.text,
                                'intrestPercentage':
                                intrestController.text,
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
                                'userEmail':
                                Provider.of<Authentication>(context,
                                    listen: false)
                                    .getUser()
                                    ?.email,
                              }).whenComplete(() {
                            Provider.of<LandingHelpers>(context,
                                listen: false)
                                .displayToast(
                                "Post uploaded successfully!",
                                context);
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
                                  'intrestPercentage':
                                  intrestController.text,
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
                                  'userEmail':
                                  Provider.of<Authentication>(
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
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection('leaderboard')
                                .doc(Provider.of<Authentication>(
                                context,
                                listen: false)
                                .getUser()
                                ?.uid)
                                .update({
                              'point': FieldValue.increment(10),
                            });
                          })
                              : Provider.of<LandingHelpers>(context,
                              listen: false)
                              .displayToast(
                              "Fill all the details!", context);
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

uploadStrategySheet(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return mybottomsheet();
      });
}

postOption(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    uploadPostSheet(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Color(0xff4b4b4b),
                        //border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(child: Text("Plan",style: TextStyle(color: Colors.white,fontSize: 18))),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    uploadStrategySheet(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Color(0xff4b4b4b),
                        //border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(child: Text("Steps",style: TextStyle(color: Colors.white,fontSize: 18))),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
