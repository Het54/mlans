import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_lans/screens/landing_page/landingHelpers.dart';
import 'package:money_lans/screens/landing_page/landingServices.dart';
import 'package:money_lans/screens/splash_screen/splashScreen.dart';
import 'package:money_lans/services/Authentication.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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
          home: const SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingServices()),
        ]);
  }
}
