import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
     Navigator.pushNamedAndRemoveUntil(
          context,
          FirebaseAuth.instance.currentUser == null ? '/landingpage' : '/home',
          (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          globalHeader: Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
              ),
            ),
          ),
          pages: [
            PageViewModel( 
              title: "Home",
              image: Image.asset("assets/images/home.jpg"),
              body:
              "Find & Share Debt Pay-Off Content That Helps To Pay-Off Debt Fast & Easily",
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Leaderboard",
              image: Image.asset("assets/images/leaderboard.jpg"),
              body:
              "The Rank Of Users Based On Debt Pay-Off Content Shared, And More Upvote The Content Gets, More Chances To Earn Money Quickly",
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Explore",
              image: Image.asset("assets/images/family.jpg"),
              body:
              "Find And Refer Tools That Helps In Paying Off Debt",
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Debt score",
              image: Image.asset("assets/images/dashboard.png"),
              body:
              "Check Your Debt Health.",
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: true,
          //rtl: true, // Display as right-to-left
          back: const Icon(Icons.arrow_back),
          skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
          next: const Icon(Icons.arrow_forward),
          done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );

  }
}