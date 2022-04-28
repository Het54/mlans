import 'package:Moneylans/screens/feedback_question/FeedbackHelpers.dart';
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
      body: Provider.of<FeedbackHelpers>(context, listen: false)
          .feedbackForm(context),
    );
  }
}
