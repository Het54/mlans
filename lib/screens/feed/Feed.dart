// ignore_for_file: prefer_const_constructors

import 'package:Moneylans/screens/leaderboard/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import 'FeedHelpers.dart';

class Feed extends StatelessWidget {
  Feed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => leaderboard(
                              userId: Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUser()
                                  ?.uid))));
                },
                child: Icon(
                  Icons.leaderboard,
                  color: Colors.black,
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          postOption(context);
        },
      ),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}

postOption(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<FeedHelpers>(context, listen: false)
                        .uploadPostSheet(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Color(0xff4b4b4b),
                        //border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(child: Text("Plan",style: TextStyle(color: Colors.white,fontSize: 18))),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<FeedHelpers>(context, listen: false)
                        .uploadStrategySheet(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Color(0xff4b4b4b),
                        //border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(child: Text("Strategy",style: TextStyle(color: Colors.white,fontSize: 18))),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
