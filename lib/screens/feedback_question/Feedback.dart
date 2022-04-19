import 'package:Moneylans/services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/FirebaseOperations.dart';
import '../landing_page/landingHelpers.dart';

class Feedbacck extends StatelessWidget {
  const Feedbacck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Moneylans",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          child: SingleChildScrollView(
            child: Column(
              children: [
                questionAns(
                    question:
                        '1. What would you use as an alternative if Moneylans were not available?'),
                Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                SizedBox(height: 5),
                questionAns(
                    question:
                        '2. What is the hardest part about paying off debt/loan?'),
                Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                SizedBox(height: 5),
                questionAns(question: '3. Why was debt payoff hard?'),
                Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                SizedBox(height: 5),
                questionAns(
                    question:
                        '4. What, if any have you done to try to solve this problem?'),
                Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                SizedBox(height: 5),
                questionAns(
                    question:
                        '5. What dont you love about the solution youve tried?'),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .activatePremium(
                            Provider.of<Authentication>(context, listen: false)
                                .getUser()!
                                .uid,
                            {
                          'premium': true,
                        }).whenComplete(() {
                      Provider.of<LandingHelpers>(context, listen: false)
                          .displayToast(
                              "Welcome to the premium gang😎🔥", context);
                      Navigator.pop(context);
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
      ),
    );
  }
}

class questionAns extends StatelessWidget {
  String question;
  questionAns({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
