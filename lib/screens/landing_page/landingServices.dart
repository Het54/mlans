// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_lans/screens/landing_page/landingUtils.dart';
import 'package:money_lans/services/Authentication.dart';
import 'package:money_lans/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../home_page/homePage.dart';

class LandingServices with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _loginkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Widget passwordLessSignin(BuildContext context) {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.4,
  //     width: MediaQuery.of(context).size.width,
  //     child: StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('allUsers').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else {
  //           return ListView.builder(
  //               itemBuilder: snapshot.data?.docs.map((e) {

  //               }).toList());
  //         }
  //       },
  //     ),
  //   );
  // }

  showUserImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.black,
                  ),
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.red,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userImage),
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<LandingUtils>(context, listen: false)
                                  .pickUserImage(context, ImageSource.gallery);
                            },
                            child: Text("Reselect")),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadUserImage(context)
                                  .whenComplete(() {
                                signInSheet(context);
                              });
                            },
                            child: Text("Confirm")),
                      ]),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ),
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 150.0),
                        child: Divider(
                          thickness: 4.0,
                          color: Colors.black,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: FileImage(
                            Provider.of<LandingUtils>(context, listen: false)
                                .getUserImage),
                        radius: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "You can't leave empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText:
                                "Enter your username (try to keep hidden)..",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "You can't leave empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your E-Mail..",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.length < 10) {
                              return "Wrong number!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your phone number..",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.name,
                          obscureText: true,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password can't be of less than 6 characters";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your password..",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      FloatingActionButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            Provider.of<Authentication>(context, listen: false)
                                .createNewAccount(emailController.text,
                                    passwordController.text)
                                .whenComplete(() {
                              print("Creating Collection...");
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'userEmail': emailController.text,
                                'username': usernameController.text,
                                'userPhone': phoneController.text,
                                'userImage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserImageUrl,
                              });
                            }).whenComplete(() {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .addUser(context, {
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'userEmail': emailController.text,
                                'username': usernameController.text,
                                'userPhone': phoneController.text,
                                'userImage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserImageUrl,
                              });
                              Fluttertoast.showToast(
                                msg: "User Registered Succesfully!", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.CENTER, // duration
                                timeInSecForIosWeb: 1,
                              );
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              // ignore: prefer_const_literals_to_create_immutables
              child: Form(
                key: _loginkey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You can't leave empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your E-Mail..",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You can't leave empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password..",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    FloatingActionButton(
                      onPressed: () {
                        if (_loginkey.currentState!.validate()) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(emailController.text,
                                  passwordController.text);

                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomePage(),
                                  type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
