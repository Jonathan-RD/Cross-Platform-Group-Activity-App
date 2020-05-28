import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'results.dart';
import 'dart:math';
import '../checkInternet.dart';
import 'package:intl/intl.dart';
import "./trendingItems.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:location/location.dart';
import 'package:flutter/services.dart';

class SearchClass extends StatefulWidget {
  String currentUserUid;
  Stream<DocumentSnapshot> stream;

  SearchClass(this.currentUserUid, this.stream);

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<SearchClass> {
  String profileImage;

  List<String> newImages = [
    "assets/suggestions/drinks.png",
    "assets/suggestions/food.png",
    "assets/suggestions/lit.png",
    "assets/suggestions/gymBuddy.png",
    "assets/suggestions/trip.png",
    "assets/suggestions/coffee.png",
    "assets/suggestions/adventure.png",
    "assets/suggestions/pickup.png",
    "assets/suggestions/hang.png",
    "assets/suggestions/wonderlandPurple.png"
  ];

  List<String> suggestions = [
    "Chill Drinks",
    "Food",
    "Lit",
    "Gym Buddy",
    "Trip",
    "Coffee",
    "Adventure",
    "Pickup Game",
    "Hang out",
    "Wonderland"
  ];

  @override
  Widget build(BuildContext context) {
    // suggestions.shuffle();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Explore"),
        heroTag: "hello",
        transitionBetweenRoutes: false,
        trailing: GestureDetector(
          child: Text(
            "Add New",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: _newGroup,
        ),
      ),
      child: Container(
          height: MediaQuery.of(context).size.height,
          //- 100.0,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 0.0, crossAxisSpacing: 0.0),
            itemCount: 9,
            //map.values.toList().length,
            // padding: EdgeInsets.only(top: 100.0, bottom: 100.0),
            itemBuilder: (BuildContext context, int index) {
              return items(index);
            },
          )),
    );
  }

/// Navigates to page for new group
  void _newGroup() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => NewPost(widget.currentUserUid, widget.stream)));
  }


/// Builds grid items
  Widget items(int index) {
    return GestureDetector(
        child: Container(
          width: 80.0,
          height: 80.0,
          // margin: EdgeInsets.all(5.0),

          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: AssetImage(
                    newImages[index],
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                suggestions[index],
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 7.0,
              )
            ],
          ),
        ),
        onTap: () => Navigator.push(
            context,
            new CupertinoPageRoute(
                builder: (BuildContext context) => ResultsPage(
                    suggestions[index],
                    Firestore.instance.collection("Convos"),
                    widget.currentUserUid))));
  }
}
