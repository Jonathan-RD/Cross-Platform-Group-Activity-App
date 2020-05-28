import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutPlaid extends StatefulWidget {

  AboutPlaid(String uid, Map<String, dynamic> info) {
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(uid)
        .update(info);

    //     .whenComplete(() {
    //   Navigator.pushReplacement(context,
    //       CupertinoPageRoute(builder: (BuildContext context) => SetupPage()));
    // });
  }

  @override
  AboutPlaidState createState() {
    return new AboutPlaidState();
  }
}

class AboutPlaidState extends State<AboutPlaid> {
  List<bool> bools = [true, false, false];

  final PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Container(
      padding: new EdgeInsets.only(
        top: 16.0,
      ),
      decoration: new BoxDecoration(color: Colors.black),
      child:
          new Stack(alignment: FractionalOffset.topCenter, children: <Widget>[
        new PageView(
          onPageChanged: (int page) {
            setState(() {
            
            if (page == 0){
              bools[1] = false;
              bools[2] = false;
            }
            if (page == 1){
                bools[0] = false;
                bools[2] = false;
            }
             if (page == 2){
                bools[0] = false;
                bools[1] = false;
            }
            
            
            
      
              bools[page] = true;




            });
          },
          physics: PageScrollPhysics(),

          children: <Widget>[
            // You can have different Layouts/ Widgets in your app.

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/whiteish.png"),
                      fit: BoxFit.cover)),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/blue.png"), fit: BoxFit.cover)),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/red.png"), fit: BoxFit.cover)),
            ),
          ],
          // controller: controller,
        ),
        Positioned(
          bottom: 15.0,
          child: Row(
            children: <Widget>[
              Container(
                height: 3.0,
                width: 15.0,
                decoration: BoxDecoration(
                    //  shape: BoxShape.circle,
                    color: bools[0] == true ? Colors.white : Colors.black),
              ),
              SizedBox(
                width: 5.0,
              ),
              Container(
                height: 3.0,
                width: 15.0,
                decoration: BoxDecoration(
                    //  shape: BoxShape.circle,
                    color: bools[1] == true ? Colors.white : Colors.black),
              ),
              SizedBox(
                width: 5.0,
              ),
              Container(
                height: 3.0,
                width: 15.0,
                decoration: BoxDecoration(
                    //  shape: BoxShape.circle,
                    color: bools[2] == true ? Colors.white : Colors.black),
              )
            ],
          ),
        )

        // new CircleIndicator(
        //     controller, 3, 6.0, Colors.white70, Colors.white)),
      ]),
    ));
  }
}
