import 'package:Moneylans/screens/landing_page/landingHelpers.dart';
import 'package:Moneylans/services/Authentication.dart';
import 'package:Moneylans/services/FirebaseOperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackHelpers with ChangeNotifier {
  TextEditingController q1Controller = TextEditingController();
  TextEditingController q2Controller = TextEditingController();
  TextEditingController q3Controller = TextEditingController();
  TextEditingController q4Controller = TextEditingController();
  TextEditingController q5Controller = TextEditingController();

  questionAnswer(
      BuildContext context, String question, TextEditingController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$question",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            width: 400,
            child: TextFormField(
              controller: controller,
              minLines: 5,
              maxLines: 200,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter your answer...",
              ),
            ),
          ),
        ),
      ],
    );
  }

  feedbackForm(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Provider.of<FeedbackHelpers>(context, listen: false).questionAnswer(
                  context,
                  '1. What would you use as an alternative if Moneylans were not available?',
                  q1Controller),
              Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
              SizedBox(height: 5),
              Provider.of<FeedbackHelpers>(context, listen: false)
                  .questionAnswer(
                      context,
                      '2. What is the hardest part about paying off debt/loan?',
                      q2Controller),
              Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
              SizedBox(height: 5),
              Provider.of<FeedbackHelpers>(context, listen: false)
                  .questionAnswer(
                      context, '3. Why was debt payoff hard?', q3Controller),
              Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
              SizedBox(height: 5),
              Provider.of<FeedbackHelpers>(context, listen: false).questionAnswer(
                  context,
                  '4. What, if any have you done to try to solve this problem?',
                  q4Controller),
              Divider(
                color: Colors.white,
                thickness: 2.0,
              ),
              SizedBox(height: 5),
              Provider.of<FeedbackHelpers>(context, listen: false)
                  .questionAnswer(
                      context,
                      '5. What dont you love about the solution youve tried?',
                      q5Controller),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .uploadFeedbackData(
                          Provider.of<Authentication>(context, listen: false)
                              .getUser()!
                              .uid,
                          {
                        'Question1': q1Controller.text,
                        'Question2': q2Controller.text,
                        'Question3': q3Controller.text,
                        'Question4': q4Controller.text,
                        'Question5': q5Controller.text,
                      }).whenComplete(() {
                        int timestamp = DateTime.now().millisecondsSinceEpoch;
                        print(timestamp);
                        int ts = timestamp;
                        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
                        String datetime = tsdate.year.toString() + "/" + tsdate.month.toString() + "/" + tsdate.day.toString();
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .activatePremium(
                            Provider.of<Authentication>(context, listen: false)
                                .getUser()!
                                .uid,
                            {
                          'premium': true,
                          'premiumtimestamp': timestamp,
                        }).whenComplete(() {
                      Provider.of<LandingHelpers>(context, listen: false)
                          .displayToast(
                              "Welcome to the premium gang😎🔥", context);
                      Navigator.pop(context);
                    });
                  });
                },
                child: Container(
                  child: Center(
                      child: Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  width: MediaQuery.of(context).size.width * 0.85,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
