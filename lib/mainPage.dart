import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './settings/settings.dart';
import './settings/pic_and_status.dart';
import './events/trendingItems.dart';
import './events/search.dart';
import './checkInternet.dart';
import './events/results.dart';
import './events/results.dart';
import 'Login.dart';
import './inbox/chatPage.dart';
import 'events/new_events.dart';

class MainPage extends StatefulWidget {
  String uid;
  MainPage(this.uid);
  @override
  State<StatefulWidget> createState() => MyMainPageState();
}

class MyMainPageState extends State<MainPage> {
  
  String currentUserId;
 
  @override
  void initState() {
    CheckInternet(context).checker();
    _getUid();

    super.initState();
  }



/// Method to fetch user uid
_getUid() async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser == null) {
     Navigator.pushReplacement(context,
         MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  } else {
     setState(() {
      currentUserId = firebaseUser.uid.toString();
     });

      // FirebaseDatabase.instance.reference().child("Users").child(firebaseUser.uid).once().then((onValue){

      //  setState(() {
      //      status = onValue.value["status"];
      //   fullName = onValue.value["fullname"];
      //   profileImage = onValue.value["profileimage"];
      //   currentUserId = firebaseUser.uid.toString();
      //   firstName =onValue.value["firstname"];
      //  });

      // });

    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore().collection("Users").document(currentUserId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CupertinoPageScaffold(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              activeColor: Theme.of(context).primaryColor,
              //  backgroundColor: Theme.of(context).accentColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.conversation_bubble),
                  title: Text("Inbox"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  title: Text("Explore"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add_circled),
                  title: Text("New Group"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings),
                  title: Text("Settings"),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              assert(index >= 0 && index <= 3);
              switch (index) {
                case 0:
                  return InboxClass(
                     currentUserId, Firestore()
                          .collection("Users")
                          .document(currentUserId)
                          .snapshots());

                  break;
                case 1:
                  return SearchClass(
                      snapshot.data["uid"],
                      Firestore()
                          .collection("Users")
                          .document(currentUserId)
                          .snapshots());

                  break;
                case 2:
                  return NewPost(
                      snapshot.data["uid"],
                      Firestore()
                          .collection("Users")
                          .document(currentUserId)
                          .snapshots());
                  break;
                case 3:
                  return CupertinoTabView(
                    builder: (BuildContext context) => SettingsClass(
                        Firestore()
                            .collection("Users")
                            .document(currentUserId)
                            .snapshots(),
                        currentUserId),
                  );

                  //SettingsClass(snapshot.data["uid"], snapshot.data["profileimage"], snapshot.data["firstname"], snapshot.data["status"]);

                  break;
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
