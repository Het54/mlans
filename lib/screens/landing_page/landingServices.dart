// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/Authentication.dart';
import '../../services/FirebaseOperations.dart';
import '../home_page/homePage.dart';
import 'landingHelpers.dart';
import 'landingUtils.dart';

class LandingServices with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController loginemailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _loginkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
                /*Provider.of<LandingUtils>(context, listen: false)
                    .userImage == null ? SizedBox() : */CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.white,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userImage!),
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
                                  .uploadUserImage(context);
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
              height: MediaQuery.of(context).size.height * 0.39,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Fill it up to sign in!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your name....",
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
                              return "Fill it up to sign in!";
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
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            Provider.of<Authentication>(context, listen: false)
                                .createNewAccount(
                                    usernameController.text,
                                    phoneController.text,
                                    emailController.text,
                                    passwordController.text,
                                    context);
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
              height: MediaQuery.of(context).size.height * 0.3,
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
                        controller: loginemailController,
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
                        controller: loginpasswordController,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_loginkey.currentState!.validate()) {
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .logIntoAccount(
                                        loginemailController.text.trim(),
                                        loginpasswordController.text.trim(),
                                        context)
                                    .then((res) {
                                  if (res == "Signed in") {
                                    Provider.of<LandingHelpers>(context,
                                            listen: false)
                                        .displayToast(res, context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                            child: HomePage(
                                              name: '',
                                            ),
                                            type:
                                                PageTransitionType.bottomToTop),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    Provider.of<LandingHelpers>(context,
                                            listen: false)
                                        .displayToast(res, context);
                                  }
                                });
                              }
                            },
                            child: Text("Sign In")),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    resetPasswordSheet(context,
                                        loginemailController.text.trim()));
                          },
                          child: Text("Forgot Password?"),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ]),
                ),
              ),
            ),
          );
        });
  }

  resetPasswordSheet(BuildContext context, String email) {
    TextEditingController resetEmailController = TextEditingController();
    resetEmailController.text = email;
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(children: [
          Text("Are you sure to reset your password?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          TextField(controller: resetEmailController),
          SizedBox(height: 15),
          ElevatedButton(
              onPressed: () {
                Provider.of<Authentication>(context, listen: false)
                    .resetPassword(context, resetEmailController.text.trim())
                    .whenComplete(() => Navigator.pop(context));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.mail), Text("  Reset Password")]))
        ]),
      ),
    );
  }
}
