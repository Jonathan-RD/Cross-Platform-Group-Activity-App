import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../profile/gradients.dart';
import 'package:flutter/cupertino.dart';

import 'caption.dart';

class NewGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewGroupState();
  }
}

class NewGroupState extends State<NewGroup> {
  String currentUserUid;
  String profileImage;
  List<String> newImages = [
    "assets/suggestions/drinks.png",
    "assets/suggestions/food.png",
    "assets/suggestions/lit.png",
    "assets/suggestions/coffee.png",
    "assets/suggestions/trip.png",
    "assets/suggestions/adventure.png",
    "assets/suggestions/pickup.png",
    "assets/suggestions/hang.png",
    "assets/suggestions/wonderlandPurple.png"
  ];

  List<String> suggestions = [
    "Chill Drinks",
    "sushi",
    "Lit",
    "Coffee",
    "Trip",
    "Adventure",
    "Pickup Game",
    "Hang out",
    "Wonderland"
  ];

  List<Color> colors = [
    Color(0xff38B6FF),
    Color(0xffFFDE59),
    Color(0xff737373),
    Color(0xffFF914D),
    Color(0xff87CEEB),
    Color(0xffFF66C4),
    Color(0xffFF5757),
    Color(0xff7ED957),
    Color(0xffCB6CE6),
  ];

  void _getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(user.uid)
        .child("profileimage")
        .once()
        .then((datasnapshot) {
      setState(() {
        profileImage = datasnapshot.value.toString();
        currentUserUid = user.uid;
      });
    });
  }

  var gradient = const LinearGradient(
    begin: FractionalOffset.bottomLeft,
    end: FractionalOffset.topRight,
    colors: <Color>[
      const Color(0xff94AEFB),
      //const Color(0xFF52C3FB),
      const Color(0xff51C1FB),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Create a New Group"),
        heroTag: "hello2",
        transitionBetweenRoutes: false,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                // gridDelegate:
                //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 9,
                padding: EdgeInsets.only(top: 20.0, bottom: 100.0),
                itemBuilder: (BuildContext context, int index) {
                  return items(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget items(int index) {
    return GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            // margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: colors[index],
              // gradient: Gradients().groupGradients[index],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  height: 100.0,
                  width: 80.0,
                  child: Image.asset(newImages[index], fit: BoxFit.cover,),
                ),
                //SizedBox(width: 10.0,),
                Text(
                  suggestions[index],
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontFamily: "SF",
                      fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),

        

        onTap: () => Navigator.push(
            context,
            new CupertinoPageRoute(
                builder: (BuildContext context) =>
                    Caption(suggestions[index], newImages[index]))));
  }
}
