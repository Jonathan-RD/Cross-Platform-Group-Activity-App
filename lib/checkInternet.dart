import 'package:flutter/material.dart';


import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './settings/settings.dart';
import './settings/pic_and_status.dart';
import './events/search.dart';
import 'package:flutter/cupertino.dart';


class CheckInternet{
BuildContext context;
CheckInternet(this.context);

void checker() async{


try {
      await InternetAddress.lookup("google.com");
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "You must turn be connected to wifi or mobile data to use Squaa",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black.withOpacity(0.7,), fontFamily: "SF"),
              ),
              content: FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            );
          });
    }






}



  
}