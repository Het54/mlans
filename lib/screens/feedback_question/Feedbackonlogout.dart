
import 'dart:async';

import 'package:Moneylans/screens/feedback_question/feedbackmodel.dart';
import 'package:Moneylans/screens/feedback_question/utils.dart';
import 'package:Moneylans/screens/profile/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_feedback/emoji_feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackonLogout extends StatefulWidget {
  const FeedbackonLogout({Key? key}) : super(key: key);

  @override
  State<FeedbackonLogout> createState() => _FeedbackonLogoutState();
}


class _FeedbackonLogoutState extends State<FeedbackonLogout> {
    late int _currentScore;
    final _formkey = GlobalKey<FormState>();
    double value = 1;
    int indexTop = 1;
    String feeling = "";
    final TextEditingController shareWithUController= new TextEditingController();
    final _auth = FirebaseAuth.instance;
    
   
  @override
  Widget build(BuildContext context) {
    final labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
    final double min = 1;
    final double max = 10;
    final divisions = labels.length - 1;
    

    final shareWithUs = TextFormField(
      autofocus: false,
      minLines: 1,
      maxLines: 10,
      controller: shareWithUController,
      onSaved: (value) {
        shareWithUController.text = value!;
      },
      validator: (value) {
        if(shareWithUController.text == null || shareWithUController.text == "")
        {
          return ("Please enter a feedback!");
        }
        return null;

      },
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)),
        hintText: 'Enter a Feedback',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),  
      ),
    );

    final submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.red[300],
      child: MaterialButton(onPressed: () { 
        feedbacktoFirestore();
       },
      child: Text("Submit", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white),),
      
      ),
    );

   
     return Scaffold(
      backgroundColor: Colors.white,
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
       body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Text("How likely would you recommend  Moneylans to your family, friends & collogues?", textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: Utils.modelBuilder(
                        labels,
                        (index, label) {
                          final selectedColor = Colors.black;
                          final unselectedColor = Colors.black.withOpacity(0.3);
                          final isSelected = index <= indexTop-1;
                          final color = isSelected ? selectedColor : unselectedColor;
                      
                          return buildLabel(label: label, color: color, width: 30);
                        },
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 5,
                      thumbShape: RoundSliderThumbShape(
                        disabledThumbRadius: 10,
                        enabledThumbRadius: 10,
                      ),
                      rangeThumbShape: RoundRangeSliderThumbShape(
                        disabledThumbRadius: 10,
                        enabledThumbRadius: 10,
                      ),
                      tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 10),
                      
                      inactiveTickMarkColor: Color.fromRGBO(109, 114, 120, 1),
                      inactiveTrackColor: Color.fromRGBO(109, 114, 120, 1),
                      
                      thumbColor: Color.fromARGB(255, 86, 123, 152),
                      activeTrackColor: Colors.blue[300],
                      activeTickMarkColor: Colors.blue,
                    ),
                    child: Container(
                      
                        child: Slider(
                        value: indexTop.toDouble(), 
                        min: min,
                        max: max,
                        divisions: divisions,
                        onChanged: (value) => setState(() => this.indexTop = value.toInt()),
                        ),
                      ),
                    ),
                  
                  Text("$indexTop"),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("What do you think of our app?", textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 30,
                  ),
                  EmojiFeedback(
                    onChange: (index) {
                      setState(() {
                        if (index == 0) {
                          feeling = "Terrible";
                        } else if (index == 1) {
                          feeling = "Bad";
                        } else if (index == 2) {
                          feeling = "Ok";
                        } else if (index == 3) {
                          feeling = "Good";
                        } else if (index == 4) {
                          feeling = "Awesome";
                        }
                      });
                    },
                  ), 
                  Text(feeling),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("What would you like to share with us?", textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 20,
                  ),
                  shareWithUs,
                  SizedBox(
                    height: 20,
                  ),
                  submit,
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ), 
    );
  }

  Widget buildLabel({
    required var label,
    required double width,
    required Color color,
  }) =>
      Container(
        width: width,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ).copyWith(color: color),
        ),
      );

  feedbacktoFirestore() async {
    if(_formkey.currentState!.validate()){
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      feedbackmodel Feedbackmodel = feedbackmodel();

      Feedbackmodel.uid = user!.uid;
      Feedbackmodel.likeness = indexTop;
      Feedbackmodel.feeling = feeling;
      Feedbackmodel.feedback = shareWithUController.text;
      

      await firebaseFirestore
        .collection("Feedbackonlogout")
        .doc(user.uid)
        .set(Feedbackmodel.toMap());
      Fluttertoast.showToast(msg: "Feedback Submitted Successfully ");

    }
  }
  
}