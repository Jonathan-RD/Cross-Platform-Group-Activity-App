import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './Login.dart';
import "registration/terms.dart";
import 'package:firebase_auth/firebase_auth.dart';
import './registration/setup.dart';
import 'package:flutter/cupertino.dart';
import './registration/setup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'help.dart';
import './registration/profilePic.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  String email, password, confirmPassword, firstName, surName;
  String actionMsg;
  String gender = "Gender (Optional)";
  DateTime dob = DateTime.now();

  final _emailKey = GlobalKey<FormState>();
  final _passWordKey = GlobalKey<FormState>();
  final _confrimPassWordKey = GlobalKey<FormState>();
  final _firstNameKey = GlobalKey<FormState>();
  final _surNameKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();

  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmController = TextEditingController();

  List<String> selectedGener = ["Male", "Female", "Other"];

  void _registerUser() async {
   
    
    confirmPassword = confirmController.text;
    firstName = firstNameController.text;
    surName = surNameController.text;
    String error = "";

    if (_emailKey.currentState.validate() &&
        _passWordKey.currentState.validate() &&
        _confrimPassWordKey.currentState.validate() &&
        _firstNameKey.currentState.validate() &&
        _surNameKey.currentState.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        print(e);

        switch (e.toString()) {
          case "PlatformException(Error 17007, FIRAuthErrorDomain, The email address is already in use by another account.)":
            error += "This email address already belongs to an account";
            break;

          case "PlatformException(Error 17026, FIRAuthErrorDomain, The password must be 6 characters long or more.)":
            error += "Your password must have 6 or more characters";
        }
      }

      setState(() {
        actionMsg = error;
      });
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Map<String, dynamic> userInfo = {
      "dob": DateFormat("MM-dd-yy").format(dob).toString(),
      "firstname": firstNameController.text,
      "surname": surNameController.text,
      "fullname": firstNameController.text + " " + surNameController.text,
      "gender": gender,
      "status": " ",
      "uid": user.uid,
      "profileimage": " ",
    };

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilePic(userInfo)));
    //   FirebaseUser newUser = await FirebaseAuth.instance.currentUser();

    //  updateInfo(newUser.uid, userInfo);
  }

  updateInfo(String uid, Map<String, dynamic> info) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(uid)
        .update(info)
        .whenComplete(() {
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) => SetupPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (actionMsg == null) {
      actionMsg = " ";
    }

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          tileMode: TileMode.mirror,
          colors: <Color>[
            Color(0xFF00B7FF),
            Color(0xff00FFEE),
          ],
        ),
      ),
      child: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text("Login",
                    style: TextStyle(color: Colors.white, fontSize: 17))
              ],
            ),
          ),
          Container(
            height: 100.0,
          ),
          forms(),
          SizedBox(height: 50.0),
          Text(actionMsg,
              textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
          SizedBox(
            height: 20.0,
          ),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            color: Theme.of(context).primaryColorDark,
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            onPressed: _registerUser,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "By Clicking \"Sign Up\" you agree to our ",
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            child: Text(
              "terms and conditions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "SF",
                  color: Colors.blue,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => TermsAlert()));
            },
          ),
          SizedBox(height: 10.0),
        ],
      ),
    ));
  }

  void _sendUserToLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  Widget forms() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _firstNameKey,
            child: TextFormField(
              controller: firstNameController,
              style: TextStyle(
                  fontFamily: "SF", color: Colors.white, fontSize: 18.0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(left: 8.0, top: 15.0, bottom: 15.0),
                  errorStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "First name",
                  hintStyle:
                      TextStyle(color: Colors.grey[100], fontFamily: "SF"),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2)),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please enter your first name";
                } else if (value.replaceAll("\S", "").length == 0) {
                  return "Please enter your first name";
                }
              },
            ),
          ),

          SizedBox(
            height: 30.0,
          ),
          Form(
            key: _surNameKey,
            child: TextFormField(
              controller: surNameController,
              style: TextStyle(
                  fontFamily: "SF", color: Colors.white, fontSize: 18.0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(left: 8.0, top: 15.0, bottom: 15.0),
                  errorStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "Last name",
                  hintStyle:
                      TextStyle(color: Colors.grey[100], fontFamily: "SF"),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2)),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please enter your last name";
                } else if (value.replaceAll("\S", "").length == 0) {
                  return "Please enter your last name";
                }
              },
            ),
          ),
          SizedBox(
            height: 30.0,
          ),

          Form(
            key: _emailKey,
            child: TextFormField(
              controller: emailController,
              style: TextStyle(
                  fontFamily: "SF", color: Colors.white, fontSize: 18.0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(left: 8.0, top: 15.0, bottom: 15.0),
                  errorStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "Email",
                  hintStyle:
                      TextStyle(color: Colors.grey[100], fontFamily: "SF"),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2)),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please enter a valid email address";
                } else if (value.replaceAll("\S", "").length == 0) {
                  return "Please enter a valid email address";
                } else if (!value.contains("@") || !value.contains(".")) {
                  return "Please enter a valid email address";
                }
              },
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          // Padding( child: Text("Password", style: TextStyle( color: Theme.of(context).primaryColor, fontSize: 18.0, fontFamily: "gotham_medium"), ), padding: EdgeInsets.symmetric( horizontal: 2.0, vertical: 5.0),),
          Form(
            key: _passWordKey,
            child: TextFormField(
              autocorrect: false,
              obscureText: true,
              controller: passWordController,
              style: TextStyle(
                fontFamily: "SF",
                color: Colors.white,
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Theme.of(context).primaryColor),
                  hintText: "Password",
                  hintStyle:
                      TextStyle(color: Colors.grey[100], fontFamily: "SF"),
                  contentPadding:
                      EdgeInsets.only(left: 8.0, top: 15.0, bottom: 15.0),
                  fillColor: Colors.white.withOpacity(0.2)),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter your passwrod ";
                } else if (value.replaceAll("\S", "").length == 0) {
                  return "Please enter your password";
                }
              },
            ),
          ),

          SizedBox(
            height: 30.0,
          ),
          Form(
            key: _confrimPassWordKey,
            child: TextFormField(
              controller: confirmController,
              obscureText: true,
              autofocus: false,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "SF",
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintStyle:
                      TextStyle(color: Colors.grey[100], fontFamily: "SF"),
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                  hintText: "Confirm Password",
                  contentPadding:
                      EdgeInsets.only(left: 8.0, top: 15.0, bottom: 15.0)),
              validator: (value) {
               
                if (value.replaceAll(new RegExp('\S'), "").length == 0 || value.isEmpty) {
                  return "Please confirm your password";
                }
                if (value != passWordController.text) {
                  return "Your retyped password doesn't match your password";
                }
              },
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            children: <Widget>[
              
              SizedBox(
                width: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoDatePicker(
                              maximumYear: 2018,
                              minimumYear: 1920,
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (DateTime value) {
                                setState(() {
                                  dob = value;
                                });
                              },
                              initialDateTime: dob),
                        );

                        
                      });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color: Colors.white,
                            width: 0.5,
                            style: BorderStyle.solid)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, top: 15.0, bottom: 15.0, right: 25.0),
                      child: Text(
                          dob == null
                              ? "Birthday"
                              : DateFormat("MM-dd-yy").format(dob).toString(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
