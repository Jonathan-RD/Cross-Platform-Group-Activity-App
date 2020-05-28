import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../mainPage.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import '../inbox/chatPage.dart';
import '../profile/gradients.dart';
import 'package:intl/intl.dart';

class ResultsPage extends StatefulWidget {
  String tag;
  CollectionReference events;
  String currentUserId;
  String profilePic, name;

  ResultsPage(this.tag, this.events, this.currentUserId);

  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends State<ResultsPage> {
 
 
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: Firestore.instance.collection("Convos").snapshots(), 
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return CupertinoPageScaffold(
        backgroundColor: Color(0xfff5f5f5),
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
         
         
          actionsForegroundColor: Theme.of(context).primaryColor,
          previousPageTitle: "Explore",

          //backgroundColor: Theme.of(context).primaryColor,
          middle: Text(
            widget.tag,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
           
            itemBuilder: (BuildContext context, int index) {
              return item(snapshot, index);
            },
          ),
        ));
      },
    );
    
    
    
    
    
     

    
  }

  Widget item(AsyncSnapshot snapshot, int index) {
    return GestureDetector(
        child: Card(
            elevation: 5.0,
            // shape: RoundedRectangleBorder(
            //               borderRadius: new BorderRadius.circular(20.0)) ,
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Container(
              height: 400.0,
              child: Column(
                children: <Widget>[
                 
                        Container(
                           
                            height: 250.0,
                            width: MediaQuery.of(context).size.width - 30.0,
                            child: StreamBuilder(
                              stream: Firestore.instance.collection("Convos").document(snapshot.data["refname"]).snapshots(),
                              //.collection("members").snapshots(),
                              
                              builder: (BuildContext context, AsyncSnapshot innerSnapshot) {
                                return 
                                ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              
                                  
                              itemBuilder: (BuildContext context,
                                  
                                  int index) {
                                //Map map = innerSnapshot.data;
                                
                                return Container(
                                  height: 200.0,
                                  width: (MediaQuery.of(context).size.width -
                                          30.0) /
                                      1,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              innerSnapshot.data["pic"]),
                                          fit: BoxFit.cover,)),
                                );
                              },
                            );
                              },
                              
                              
                            )
                            
                            
                            

                            // Image.asset(
                            //   "assets/coffee.jpg",
                            //   fit: BoxFit.fill,
                            // ),
                            ),

                        //   Image.network("https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/YntQbLIaocdU0MkyvDUG5ic6ySU2.jpg?alt=media&token=b8464a15-61b9-4d56-b2c7-fc8e1b5253db"),
                    
                 
                  SizedBox(height: 30.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      //  gradient: Gradients().gradients[2]
                    ),
                    child: RaisedButton(
                      elevation: 0.0,
                      child: Text(
                        "food",
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "food",
                    style: TextStyle(
                      fontFamily: "SF",
                      fontSize: 20.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )),
        onTap: () {
          if (snapshot.data[widget.currentUserId] != null) {
            showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    message: Text("Are you sure you want to join this group?"),
                    cancelButton: CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text("Yes"),
                        onPressed: () async {
                          Navigator.pop(context);

                          await FirebaseDatabase.instance
                              .reference()
                              .child("Convos")
                              .child(snapshot.data["refname"])
                              .child(widget.currentUserId)
                              .set(widget.currentUserId)
                              .whenComplete(() {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) => ChatView(
                                        snapshot.data["chatname"],
                                        widget.currentUserId,
                                        snapshot.data["refname"], widget.name)));
                          });
                        },
                      )
                    ],
                  );
                });
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => ChatView(
                        snapshot.data["chatname"],
                        widget.currentUserId,
                        snapshot.data["refname"], widget.name)));
          }
        });
  }
}
