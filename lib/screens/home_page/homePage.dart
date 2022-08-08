import 'package:Moneylans/screens/notification/notification_screen.dart';
import 'package:Moneylans/screens/onboard_screen/OnboardScreen.dart';
import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
import 'package:Moneylans/services/local_puch_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((event) { 
      LocalNotificationService.display(event);
    });
    checkpremium();
    StoreNotificationToken();
  }

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
          });
        },
        children: [
          Feed(),
          OnboardScreen(),
          notification(),
          Profile(name: widget.name),
        ],
      ),
      bottomNavigationBar: Provider.of<homePageHelpers>(context, listen: false)
          .bottomNavBar(pageIndex, homeController),
    );
  }

  StoreNotificationToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
    .collection("userData")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .set({
      'token': token
    },SetOptions(merge: true));
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
