import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPost extends StatefulWidget {
  String currentUserUid;

  Stream<DocumentSnapshot> stream;

  NewPost(this.currentUserUid, this.stream);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewPostState();
  }
}

class NewPostState extends State<NewPost> {
  // String tag;
  // DatabaseReference events =
  //     FirebaseDatabase.instance.reference().child("Convos");

  BehaviorSubject<String> tagSpinner = BehaviorSubject.seeded("Activity");
  BehaviorSubject<String> image =
      BehaviorSubject.seeded("assets/ios/AppIcon.png");
  final statusController = TextEditingController();

  List<String> suggestions = [
    "Chill Drinks",
    "sushi",
    "Lit",
    "Gym Buddy",
    "Trip",
    "Coffee",
    "Adventure",
    "Pickup Game",
    "Hang out",
    "Wonderland"
  ];

  List<String> images = [
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            trailing: GestureDetector(
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () => _postEvent(snapshot.data["profileimage"])),
            middle: Text(
              "New Group",
            ),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        StreamBuilder(
                          stream: image.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot imageSnapshot) {
                            if (imageSnapshot.hasData) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 5.0, bottom: 15.0, top: 15.0),
                                height: 125.0,
                                width: 125.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(imageSnapshot.data),
                                  fit: BoxFit.cover,
                                )),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 150.0,
                        height: 170.0,
                        child: TextField(
                          controller: statusController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15.0),
                            border: InputBorder.none,
                            hintText: "   Caption",
                          ),
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: CupertinoColors.inactiveGray,
                            width: 0.5,
                            style: BorderStyle.solid))),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            style: BorderStyle.solid,
                            width: 0.5,
                            color: CupertinoColors.inactiveGray))),
                child: ListTile(
                  title: StreamBuilder(
                    stream: tagSpinner.stream,
                    builder: (BuildContext context, AsyncSnapshot tagSnapshot) {
                      if (tagSnapshot.hasData) return Text(snapshot.data);
                    },
                  ),
                  onTap: _bottomSheet,
                  trailing: Icon(
                    CupertinoIcons.right_chevron,
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows bottom sheet picker for activity
  void _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(CupertinoPicker(
            backgroundColor: Colors.white,
            useMagnifier: true,
            children: suggestions.map((value) {
              return Text(
                value,
              );
            }).toList(),
            onSelectedItemChanged: (value) {
              tagSpinner.add(suggestions[value]);
              image.add(images[value]);
            },
            itemExtent: 45.0,
            offAxisFraction: 0.0,
            diameterRatio: 1.1,
          ));
        });
  }

  /// Creates conversation reference key which holds metadata
  /// Metadata points to location of messages
  String _convoReference() {
    String key;

    Firestore.instance.collection("Messages").add({}).then((onValue) {
      key = onValue.documentID;
    });

    return key;
  }

  /// Alert Dialog to show error
  Widget _dialog() {
    return CupertinoAlertDialog(
      title: Text("Please select an activity below"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Ok"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  /// Method which posts event
  /// Takes in profile image url to make things easier
  void _postEvent(String profileImage) async {
    if ( tagSpinner.value != "Activity") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return _dialog();
          });
    } else {
      DateTime bleh = DateTime.now();
      String date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      String x = TimeOfDay.now().hour.toString() +
          ":" +
          TimeOfDay.now().minute.toString() +
          "00";

      String key = _convoReference();

      String post = widget.currentUserUid + DateTime.now().toString();

      Firestore.instance.collection("Convos").document(post).setData({
        "text": statusController.text,
        "refname": widget.currentUserUid + bleh.toString(),
        "tag": tagSpinner.value,
        "date": date + " " + x,
        "convopic": profileImage,
        "chatname": key,
        "uid": widget.currentUserUid,
        "lastmessage": statusController.text,
        "convonickname": "yolo",
        widget.currentUserUid: widget.currentUserUid,
        "locked": false,
      });
    }
  }

  /// Builds the bottom modal picker
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
