import 'package:Moneylans/screens/onboard_screen/OnboardScreenHelpers.dart';
import 'package:Moneylans/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userData')
          .doc(Provider.of<Authentication>(context, listen: false)
              .getUser()
              ?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: snapshot.data!.get('premium') == true
                ? AppBar(
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
                            showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return Provider.of<OnboardScreenHelpers>(
                                          context,
                                          listen: false)
                                      .premiumCard(context);
                                });
                          },
                          child: Icon(Icons.group_add_outlined,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  )
                : null,
            body: snapshot.data!.get('premium') == false
                ? Provider.of<OnboardScreenHelpers>(context, listen: false)
                    .notPremium(context)
                : Provider.of<OnboardScreenHelpers>(context, listen: false)
                    .premiumOnboard(context),
          );
        }
      },
    );
  }
}
