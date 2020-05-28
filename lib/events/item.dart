import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'results.dart';
import 'dart:math';
import '../checkInternet.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  Widget item(int index, List<String> suggestions, List<String> images) {
    return
        // Card(

        //                           elevation: 7.0,
        //                           margin: EdgeInsets.symmetric(horizontal: 10.0),
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius: new BorderRadius.circular(20.0)),
        //                           child:
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
            //margin: EdgeInsets.symmetric( horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black.withAlpha(70),
                      offset: const Offset(3.0, 10.0),
                      blurRadius: 10.0)
                ],
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                    image: AssetImage(images[index]),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.modulate))),
            width: 150,
            height: 200.0,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 25.0,
                  decoration: BoxDecoration(
                      color: Color(0xFF00B7FF),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0))),
                  width: 150.0,
                  // color: Colors.black,
                  child: Text(
                    suggestions[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                       
                        fontFamily: "SF",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                )));
    // onTap: () => Navigator.push(
    //     context,
    //     new CupertinoPageRoute(
    //         builder: (BuildContext context) => ResultsPage(
    //             suggestions[index], events, currentUserUid)))
    // );
  }
}
