import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'gradients.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ProfileClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileClass> {
  String currentUserId;
  String name, status, education;
  String profilePic;

  List<dynamic> hobbies = [];

  @override
  initState() {
    getValues();

    super.initState();
  }

  void getValues() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    currentUserId = user.uid;

    await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(user.uid)
        .once()
        .then((snapshot) {
      setState(() {
        name = snapshot.value["fullname"];
        currentUserId = user.uid;
        status = snapshot.value["status"];
        profilePic = snapshot.value["profileimage"];
        hobbies = snapshot.value["hobbies"];
        // skills.forEach((key, value) {
        //   downloadedSkills.add(value.toString());
        // });
      });
    });

//  setState(() {
//     skills.forEach((key,value){
//         downloadedSkills.add(value);
//         });
//   });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: CustomScrollView(
          //shrinkWrap: true,
          slivers: <Widget>[
           
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 350.0,
              backgroundColor: Colors.indigo,
              flexibleSpace: FlexibleSpaceBar(

                  //collapseMode: CollapseMode.pin,
                  background: Image.network(profilePic, fit: BoxFit.cover,) ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                   
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 14.0),
                      child: Text(
                        name == null ? " " : name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                           color: Colors.black.withOpacity(0.7),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "montserrat"),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Badges",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                           color: Colors.black.withOpacity(0.7),
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    Theme(
                      data: ThemeData(fontFamily: "montserrat"),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          // query: FirebaseDatabase.instance.reference().child("Artists").child("II9K4fm8JjUqe42NSG9rXROHynY2").child("skils"),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 7.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: Gradients().gradients[index]),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                elevation: 0.0,
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                color: Colors.transparent,
                                child: Text(
                                  hobbies.length == 0 ? " " : hobbies[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                       

                       
                      ),
                    ), SizedBox( height: 500.0,),
                  ])
            ])),
          ]),
    );
  }
}
