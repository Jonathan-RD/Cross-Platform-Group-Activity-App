import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../profile/gradients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './results.dart';
import '../checkInternet.dart';
import 'package:intl/intl.dart';


class Caption extends StatefulWidget {
  String tag;
  String image;
  Caption(this.tag, this.image);

  @override
  State<StatefulWidget> createState() {
    return CaptionState();
  }
}

class CaptionState extends State<Caption> {
  final _statusController = TextEditingController();
  String counter;
  String caption;
  String currentUserUid;
 DocumentReference events;
  String profileImage;



  @override
  void initState() {
    //focusNode.addListener(() {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _getUid();
  
    CheckInternet(context).checker();
   // events = FirebaseDatabase.instance.reference().child("Convos");

    super.initState();
  }

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


// void _postEvent(String value) async {
  
//         String bleh = DateTime.now().millisecondsSinceEpoch.toString();
//         String date = DateFormat("MM-dd-yy").format(DateTime.now()).toString();
//         String key = convoReference();
//         Map<String, dynamic> map = {
//           "text": value,
//           "refname": currentUserUid + bleh,
//           "tag": widget.tag,
//           "date": date,
//           "time": TimeOfDay.now().hour.toString() + ":" + TimeOfDay.now().minute.toString(),
//           "convopic": profileImage,
//           "chatname": key,
//           "uid": currentUserUid,
//           "lastmessage": value,
//           "convonickname": "yolo",
//           currentUserUid: currentUserUid,
//           "locked": false,

//           // "latitude": currentLocation["longitude"],
//           // "longitude": currentLocation["latitude"]
//         };

//         await events.child(currentUserUid + bleh).update(map).whenComplete(() {
         
//          events.child(currentUserUid + bleh).child("members").child(currentUserUid).child("pic").set(profileImage);
//          Navigator.pop(context);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext contrxt) =>
//                       ResultsPage(widget.tag, events , currentUserUid)));
//         });
//       }
    
  



String convoReference() {
    String key =
        FirebaseDatabase.instance.reference().child("Messages").push().key;

    return key;
  }




  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          actionsForegroundColor: Theme.of(context).primaryColor,
          middle: Text("Caption"),
          trailing: GestureDetector(
            child: Text("Create Group", style:TextStyle(decoration: TextDecoration.none, fontFamily: "SF", fontSize: 17.0, color: Theme.of(context).primaryColor)),
          onTap: (){
          //  _postEvent(caption);
          },
          ),
        ),
        child: Scaffold(
          body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 40.0),
                height: 400.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(widget.image), fit: BoxFit.cover)),
              ),
             
              Container(
                padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                child: TextField(
                  controller: _statusController,
                  maxLength: 145,
                  maxLines: 5,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 20.0),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    counterStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 15.0),
                    counterText:
                        (145 - _statusController.text.length).toString(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
                    hintText: "Caption",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),

                    //hintText: widget.status == null ? "Hey, I'm using Sqwah" : widget.status
                  ),
                  onChanged: (String value) {
                    setState(() {
                      caption = value;
                      counter = (140 - value.length).toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
