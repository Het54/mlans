// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:money_lans/profile/ProfileHelpers.dart';
import 'package:money_lans/screens/home_page/homePage.dart';
import 'package:money_lans/screens/home_page/homePageHelpers.dart';
import 'package:money_lans/screens/landing_page/landingHelpers.dart';
import 'package:money_lans/screens/landing_page/landingPage.dart';
import 'package:money_lans/screens/landing_page/landingServices.dart';
import 'package:money_lans/screens/landing_page/landingUtils.dart';
import 'package:money_lans/screens/splash_screen/splashScreen.dart';
import 'package:money_lans/services/Authentication.dart';
import 'package:money_lans/services/FirebaseOperations.dart';
import 'package:money_lans/utils/PostOptions.dart';
import 'package:provider/provider.dart';

import 'feed/FeedHelpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("user");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.blue,
            canvasColor: Colors.transparent,
          ),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => SplashScreen(),
            '/landingpage': (context) => LandingPage(),
            '/home': (context) => HomePage(),
          },
          home: const SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => PostOptions()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => homePageHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingServices()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
        ]);
  }
}
