import "package:flutter/material.dart";
import "./settings.dart";
import 'package:firebase_auth/firebase_auth.dart';
import '../Login.dart';
import '../mainPage.dart';
import 'package:flutter/cupertino.dart';
import './change.dart';
import 'help/help.dart';

class Tiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text(
            "Account Settings",
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
            textAlign: TextAlign.start,
          ),
          padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid)),
          child: ListTile(
            enabled: true,
            leading: Row(
              children: <Widget>[
                Icon(CupertinoIcons.padlock, color: Colors.yellow[600]),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => ChangePage()));
            },
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Padding(
          child: Text(
            "App Settings",
            style: TextStyle(color: Colors.black.withOpacity(0.7)),
            textAlign: TextAlign.start,
          ),
          padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid)),
          child: ListTile(
            enabled: true,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            leading: Row(
              children: <Widget>[
                Icon(
                  CupertinoIcons.conversation_bubble,
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Chat settings",
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
            onTap: () {},
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid)),
          child: ListTile(
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            enabled: true,
            leading: Row(
              children: <Widget>[
                Icon(
                  CupertinoIcons.info,
                  color: CupertinoColors.activeBlue,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Help",
                    style: TextStyle(color: Colors.black.withOpacity(0.7))),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => Help()));
            },
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid)),
          child: ListTile(
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
              ),
              enabled: true,
              leading: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    color: Color(0xff454553),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("Sign out",
                      style: TextStyle(color: Colors.black.withOpacity(0.7))),
                ],
              ),
              onTap: () => _logoutCheck(context),
                
            
        ),)
      ],
    );
  }







void _logoutCheck(BuildContext context){

showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        message: Text("Are you sure you want to log out?"),
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontFamily: "SF"),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              child: Text("Log out"),
                              onPressed: () {
                                FirebaseAuth.instance.signOut().whenComplete(
                                  () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginPage()),
                                        (_) => false);
                                  },
                                );
                              })
                        ],
                      );
                    });

}





}
