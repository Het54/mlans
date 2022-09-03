import 'dart:ui';
import 'package:Moneylans/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Moneylans/screens/feedback_question/Feedback.dart';
import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:Moneylans/services/Authentication.dart';
import 'package:Moneylans/services/FirebaseOperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

String barcodeScanRes='abcdefgh';

// String? uid = Provider.of<Authentication>(  context, listen: false).getUser()?.uid;

 TextEditingController UIDcontroller = TextEditingController();


class OnboardScreenHelpers with ChangeNotifier {
  TextEditingController PINcontroller = TextEditingController();
  TextEditingController UIDcontroller = TextEditingController();
  
  notPremium(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJkqaMY2BZD5-jwCaWlcBTTjamnzlMthxazA&usqp=CAU"),
              fit: BoxFit.cover,
            ),
          ),
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: new Container(
              decoration:
              new BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        Center(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.35,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You need to be a premium member",
                    style: TextStyle(color: Colors.black)),
                Text("to access this feature :(",
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text("Join Premium Club"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Feedbacck(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text("Premium Member Out Of Top 3 Is Declared",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text("Winner Of The Week On The Home Screen",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  premiumOnboard(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          ],
        ),
      ),
    );
  }

  premiumCard(BuildContext context) {


    return Dialog(
      insetAnimationCurve: Curves.easeInCirc,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.45,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1638913970961-1946e5ee65c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxzZWFyY2h8MzZ8fG1vbmV5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Moneylans Premium",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Provider.of<OnboardScreenHelpers>(context,
                            listen: false)
                            .premiumCodeDisplay(context);
                      });
                },
                child: Text("Know your secret code!",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    )),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                )),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Provider.of<OnboardScreenHelpers>(context,
                          listen: false)
                          .premiumCodeCheck(context);
                    });
              },
              child: Text("Onboard your partner!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
              ),
            ),
            SizedBox(height: 3,),

          ],
        ),
      ),
    );
  }


  Comingsoon(BuildContext context) {


    return Dialog(
      insetAnimationCurve: Curves.easeInCirc,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.2,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1534175507998-e5477e27c2c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Coming Soon...",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            
          ],
        ),
      ),
    );
  }

  premiumCodeDisplay(BuildContext context) {
    return Dialog(
      insetAnimationCurve: Curves.easeInCirc,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.25,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1638913970961-1946e5ee65c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxzZWFyY2h8MzZ8fG1vbmV5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Your onboard code:",
                    style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
              ),

            ),
            SizedBox(height: 15),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(
                  "${Provider
                      .of<Authentication>(context, listen: false)
                      .getUser()
                      ?.uid}")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Text(snapshot.data!.get('onBoardCode'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.yellow));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  premiumCodeCheck(BuildContext context) {

    return Dialog(
    insetAnimationCurve: Curves.easeInCirc,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1638913970961-1946e5ee65c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxzZWFyY2h8MzZ8fG1vbmV5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add member:",
                    style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
            ),
            SizedBox(height: 15),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: () => _scanqrState().scanQR() ,
                        icon: Icon(Icons.camera_alt_outlined)),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      width: 240,
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: barcodeScanRes,
                             hintText: "Enter UID Or Scan code...",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                             fillColor: Colors.white,
                            focusColor: Colors.white,
                            filled: true),
                        controller: UIDcontroller,
                      ),
                    ),
                  ),

                ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: PINcontroller,
                decoration: InputDecoration(
                    hintText: "Enter PIN...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    filled: true),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Provider.of<FirebaseOperations>(context, listen: false)
                    .onboardMember(UIDcontroller.text, PINcontroller.text);
                },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Text("Check"),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class scanqr extends StatefulWidget {
  const scanqr({Key? key}) : super(key: key);

  @override
  State<scanqr> createState() => _scanqrState();
}
class _scanqrState extends State<scanqr> {
  @override
  Widget build(BuildContext context) {

    return SizedBox(height: 0);
  }
  void scanQR() async {
    try {
       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
     setState((){ UIDcontroller.text= barcodeScanRes;
        print(UIDcontroller);
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform';
    }

    // setState(()=> qrcreate(barcodeScanRes));
  }
  // void qrcreate(barcodeScanRes) {
  //    setState(() => UIDcontroller = barcodeScanRes);
  //   }

}

