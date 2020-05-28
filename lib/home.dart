import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:location/location.dart';
import 'package:flutter/services.dart';
import './inbox/chatPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import './inbox/DateComparison.dart';

class InboxClass extends StatefulWidget {
  String currentUserId;
  Stream<DocumentSnapshot> stream;
  InboxClass(this.currentUserId, this.stream);

  @override
  State<StatefulWidget> createState() {
    return InboxState();
  }
}

class InboxState extends State<InboxClass> {
  DatabaseReference convos;

  FirebaseUser user;
  //String url;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Container(
                height: 100.0,
                width: 100.0,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        } else {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  //heroTag: UniqueKey(),
                  // transitionBetweenRoutes: false,

                  padding: EdgeInsetsDirectional.only(top: 10.0, end: 15.0),

                  largeTitle: Text(
                    "Inbox",
                    style: TextStyle(
                      //color: Theme.of(context).primaryColor,
                      fontFamily: "SF",
                    ),
                    softWrap: true,
                  ),
                ),
                SliverFillViewport(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Scaffold(
                        // backgroundColor: Color(0xffF5F5F7),
                        body: StreamBuilder(
                          stream: Firestore.instance
                              .collection("Convos")
                              .where(widget.currentUserId,
                                  isEqualTo: widget.currentUserId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot chatSnapshot) {
                            return ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return itemeBuilder(
                                    chatSnapshot, context, snapshot);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget itemeBuilder(AsyncSnapshot chatSnapshot, BuildContext context,
      AsyncSnapshot userSnapshot) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                    style: BorderStyle.solid))),
        child: ListTile(
            trailing: Text(chatSnapshot.data["date"] == null
                ? " "
                : DateComparison().compare(chatSnapshot.data["date"])),
            enabled: true,
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 32.0,
              child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(chatSnapshot.data["convopic"])),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chatSnapshot.data["convonickname"],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  chatSnapshot.data["lastmessage"],
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                )
              ],
              // ),
              // ],
            ),
            onLongPress: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      cancelButton: Text(
                        "Cancel",
                        style: TextStyle(
                            fontFamily: "SF",
                            decoration: TextDecoration.none,
                            color: CupertinoColors.activeBlue),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            child: Text("Leave Group"),
                            onPressed: () {
                              Navigator.pop(context);
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("Convos")
                                  .child(chatSnapshot.data["refname"])
                                  .child(widget.currentUserId)
                                  .remove();

                              FirebaseDatabase.instance
                                  .reference()
                                  .child("Convos")
                                  .child(chatSnapshot.data["refname"])
                                  .child("members")
                                  .child(widget.currentUserId)
                                  .remove();
                            })
                      ],
                    );
                  });
            },
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => ChatView(
                          chatSnapshot.data["chatname"],
                          widget.currentUserId,
                          chatSnapshot.data["refname"],
                          userSnapshot.data["firstname"])));
            }));
  }
}
