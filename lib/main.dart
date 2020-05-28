import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './mainPage.dart';
import "./Login.dart";
import './inbox/chatPage.dart';
import 'intro.dart';
import './help.dart';
import './profile/profilePage.dart';
import 'Register.dart';
import './registration/profilePic.dart';
import './settings/help/FAQ.dart';
import './events/results.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Map<String, dynamic> userInfo = {
    "dob": 12,
    "firstname": 12,
    "surname": 1,
    "fullname": 1,
    "gender": 1,
    "status": " ",
    "uid": 1,
    "profileimage": " ",
  };
  DatabaseReference events = FirebaseDatabase.instance.reference().child("Convos");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          fontFamily: "SF",
          primaryColor: Color(0xFF00B7FF),
          //Color(0xFFff2d55),
        
          accentColor: Color(0xffcce6ef),
          primaryColorDark: Color(0xFF499FD4),
          canvasColor: Color(0xfffbfbff),
          highlightColor: Color(0xff7DF489),
          cardColor: Color(0xfff5f5f5),
          brightness: Brightness.light,
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.light),

      home: 
      //ResultsPage("sushi", events, "YntQbLIaocdU0MkyvDUG5ic6ySU2")
      //AboutPlaid("uid", userInfo),
      //FAQ(),
         // LoginPage()
          //ProfilePic(userInfo),
    MainPage("uid"),
      //ProfileClass(),
      //RegisterPage(),
    );
  }
}
