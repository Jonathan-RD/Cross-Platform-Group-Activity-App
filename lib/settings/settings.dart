import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import './settingsTiles.dart';
import './pic_and_status.dart';
import 'package:flutter/cupertino.dart';

class SettingsClass extends StatelessWidget {
  Stream<DocumentSnapshot> stream;
  String uid;
  SettingsClass(this.stream, this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              body: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  "Settings",
                  softWrap: true,
                  style: TextStyle(fontFamily: "SF"),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  //  Scaffold(
                  //     body:
                  Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 0.5,
                                color: Colors.grey.withOpacity(0.5),
                                style: BorderStyle.solid)),
                        child: Container(
                          // color: Theme.of(context).primaryColor,
                          child: ListTile(
                              enabled: true,
                              contentPadding: EdgeInsets.all(20.0),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.grey,
                              ),
                              leading: CircleAvatar(
                                radius: 43.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage: NetworkImage(
                                        snapshot.data["profileimage"])),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data["fullname"],
                                    style: TextStyle(
                                        fontFamily: "SF",
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    snapshot.data["status"],
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "SF",
                                        color: Colors.black.withOpacity(0.7)),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          PicStatus(
                                              stream, uid
                                              
                                              )))),
                        ),
                      ),
                      SizedBox(height: 100.0),
                      Tiles(),
                      SizedBox(
                        height: 100.0,
                      )
                    ],
                  )
                  //)
                ]),
              )
            ],
          ));
        } 
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  
}


