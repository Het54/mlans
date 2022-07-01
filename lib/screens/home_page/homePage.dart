import 'package:Moneylans/screens/onboard_screen/OnboardScreen.dart';
import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../feed/Feed.dart';
import '../profile/Profile.dart';
import 'homePageHelpers.dart';

class HomePage extends StatefulWidget {
  String name;
  HomePage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homeController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: homeController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
            checkpremium();
          });
        },
        children: [
          Feed(),
          OnboardScreen(),
          Profile(name: widget.name),
        ],
      ),
      bottomNavigationBar: Provider.of<homePageHelpers>(context, listen: false)
          .bottomNavBar(pageIndex, homeController),
    );
  }

  checkpremium() async{
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    FirebaseFirestore.instance
    .collection('userData')
    .doc(user!.uid)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        var a = documentSnapshot.data();
        Map.from(a  as Map<String, dynamic>);
        int usertimestamp = a["premiumtimestamp"];
        print(usertimestamp);
        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(usertimestamp);
        String datetime = tsdate.year.toString() + "/" + tsdate.month.toString() + "/" + tsdate.day.toString();
        final userdate = DateTime(tsdate.year, tsdate.month, tsdate.day);
        final currentdate = DateTime.now();
        final difference = currentdate.difference(userdate).inDays;
        print(difference);
        if(difference>29){
          FirebaseFirestore.instance
          .collection('userData')
          .doc(user.uid)
          .update({
          'premium': false,
        });
        }
      }
    });
  }
}
