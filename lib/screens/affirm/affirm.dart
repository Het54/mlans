import 'dart:ui';
import 'package:Moneylans/screens/affirm/storyScreen.dart';
import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:Moneylans/services/Authentication.dart';
import 'package:Moneylans/services/FirebaseOperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


bool alreadyAffirm = false;
List affirmList = [];
class affirm extends StatefulWidget {
  const affirm({Key? key}) : super(key: key);

  @override
  State<affirm> createState() => _affirmState();
}

class _affirmState extends State<affirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Affirm",
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
            uploadAffirmSheet(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Container(
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
                onRefresh: () {
                  return Future(() => Future.delayed(Duration(seconds: 1)));
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Affirm')
                      .orderBy("latestTime",descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return loadAffirm(context, snapshot);
                    }
                  },
                ),
              ),
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
    );
  }


  Widget loadAffirm(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    String userID = Provider.of<Authentication>(context, listen: false).getUser()!.uid;
    return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
          DateTime latestTime = data["latestTime"].toDate();

          if (data["userId"] == userID) {
            alreadyAffirm = true;
            affirmList = data["affirm"];
          }

          return GestureDetector(
            onTap: ()=> Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                    storyScreeen(
                        storyList : data["affirm"],
                        postUserId : data["userId"]
                    ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(15),
                  border: data["affirm"][data["affirm"].length -1]["views"].contains(userID)
                      ? Border.all(color: Colors.grey.shade400,width: 2)
                      : Border.all(color: Colors.blueAccent,width: 2)
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(data['userId'],style: TextStyle(fontSize: 15)),
                    ),
                    if( DateTime.now().difference(latestTime).inMinutes < 60 )
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("${DateTime.now().difference(latestTime).inMinutes} m"),
                      )
                    else if(DateTime.now().difference(latestTime).inMinutes > 59 && DateTime.now().difference(latestTime).inHours < 23)
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("${DateTime.now().difference(latestTime).inHours} h"),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("${DateTime.now().difference(latestTime).inDays} d"),
                      )
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }

  TextEditingController affirmController = TextEditingController();
  uploadAffirmSheet(BuildContext context) {
    String userID = Provider.of<Authentication>(context, listen: false).getUser()!.uid;
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
              height: MediaQuery.of(context).size.height * 0.3,
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
                        maxLines: 5,
                        maxLength: 250,
                        controller: affirmController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Affirm Story",
                          hintText: "Enter the affirm story...",
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
                              affirmController.clear();
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        ElevatedButton(
                          onPressed: () async {

                            if(affirmController.text.isNotEmpty && alreadyAffirm==true) {
                              affirmList.add({
                                "time" : DateTime.now(),
                                "title" : affirmController.text,
                                "views" : []
                              });

                              Provider.of<FirebaseOperations>(context, listen: false).addAffirmData(
                                  context,
                                  userID,
                                  {
                                    'affirm': affirmList,
                                    'latestTime': Timestamp.now(),
                                  }
                              ).whenComplete(() {
                                Provider.of<LandingHelpers>(context, listen: false).displayToast("Post added successfully!", context);
                              })
                                  .whenComplete(() {
                                    affirmController.clear();
                                    Navigator.pop(context);
                                  });
                            }
                            else if(affirmController.text.isNotEmpty && alreadyAffirm==false)
                              Provider.of<FirebaseOperations>(context, listen: false)
                                  .uploadAffirmData(
                                    context,
                                    userID,
                                    {
                                    'affirm': [
                                      {
                                        'title': affirmController.text,
                                        'time': Timestamp.now(),
                                        'views': []
                                      }
                                    ],
                                    'latestTime': Timestamp.now(),
                                    'userId': userID,
                                  }
                                    )
                                    .whenComplete(() {Provider.of<LandingHelpers>(context, listen: false)
                                    .displayToast("Post uploaded successfully!", context);})
                                    .whenComplete(() {
                                      alreadyAffirm = true;
                                      affirmController.clear();
                                      Navigator.pop(context);
                                    });
                              else
                                Provider.of<LandingHelpers>(context, listen: false).displayToast("Fill the affirm first!", context);

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
}
