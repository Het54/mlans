// ignore_for_file: deprecated_member_use
import 'package:Moneylans/screens/debt_meter/DebtMeter_helpers.dart';
import 'package:Moneylans/screens/feed/FeedHelpers.dart';
import 'package:Moneylans/screens/feedback_question/Feedback.dart';
import 'package:Moneylans/screens/feedback_question/FeedbackHelpers.dart';
import 'package:Moneylans/screens/home_page/homePage.dart';
import 'package:Moneylans/screens/home_page/homePageHelpers.dart';
import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:Moneylans/screens/landing_page/landingPage.dart';
import 'package:Moneylans/screens/landing_page/landingServices.dart';
import 'package:Moneylans/screens/landing_page/landingUtils.dart';
import 'package:Moneylans/screens/onboard_screen/OnboardScreenHelpers.dart';
import 'package:Moneylans/screens/profile/ProfileHelpers.dart';
import 'package:Moneylans/screens/splash_screen/splashScreen.dart';
import 'package:Moneylans/services/Authentication.dart';
import 'package:Moneylans/services/FirebaseOperations.dart';
import 'package:Moneylans/utils/PostOptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final userReference = FirebaseDatabase.instance;
final userRef = userReference.reference().child("user");

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
            '/feedback': (context) => Feedbacck(),
            '/landingpage': (context) => LandingPage(),
            '/home': (context) => HomePage(
                  name: '',
                ),
          },
          home: const SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => PostOptions()),
          ChangeNotifierProvider(create: (_) => FeedbackHelpers()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => OnboardScreenHelpers()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => DebtMeterHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => homePageHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingServices()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
        ]);
  }
}
