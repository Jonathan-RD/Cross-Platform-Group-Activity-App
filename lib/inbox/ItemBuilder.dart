import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
//import '../profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'picView.dart';

class ItemBuilder extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation<double> animation;
  final Map<String, dynamic> colors;
  String currentUserUid;

  final List<Color> nameColor = [
    Color(0xFF39003E),
    Colors.blue,
    Color(0xff05F1FF),
    Color(0xFFec696a)
  ];

  ItemBuilder(this.currentUserUid, this.colors,
      {this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    print(messageSnapshot.value["imageUrl"]);
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: currentUserUid == messageSnapshot.value["userUid"]
              ? sentMessageLayout(context)
              : receivedMessageLayout(context),
        ),
      ),
    );
  }

  List<Widget> sentMessageLayout(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                messageSnapshot.value["sender"],
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "SF",
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: pic(Theme.of(context).primaryColor, context),
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> receivedMessageLayout(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // GestureDetector(
            //   child:
            Text(
              messageSnapshot.value["sender"],
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => ProfilePage())),
            // ),
            Container(
                margin: EdgeInsets.only(top: 5.0),
                child: pic(CupertinoColors.activeGreen, context))
          ],
        ),
      ),
    ];
  }

  Widget pic(Color color, BuildContext context) {
    Widget widget;
    if (messageSnapshot.value["imageUrl"] != null &&
        messageSnapshot.value["text"] == null) {
      widget = GestureDetector(
        child: Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage(
                    messageSnapshot.value["imageUrl"],
                  ),
                  fit: BoxFit.cover)),
        ),
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (BuildContext context,
                Animation animation, Animation secondaryAnimation) {
              return PicView(messageSnapshot.value["imageUrl"]);
            }, transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.00, 1.00, curve: Curves.linear),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.5,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.50, 1.00, curve: Curves.linear),
                    ),
                  ),
                  child: child,
                ),
              );
            })),
      );
    } 
    
    
    
    else if (messageSnapshot.value["text"] != null) {
      widget = Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: color, borderRadius: new BorderRadius.circular(20.0)),
        child: Text(
          messageSnapshot.value["text"],
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      widget = Container(
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10.0),
           color: color, 
        ),
       
        height: 200.0,
        width: 200.0,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
      );
    }
    return widget;
  }
}
