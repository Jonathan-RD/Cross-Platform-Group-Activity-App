import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CustomShapeClipper.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
      begin: FractionalOffset.topLeft,
      end: FractionalOffset.bottomRight,
      tileMode: TileMode.mirror,
     
      colors: <Color>[
    //    Color(0xfff05053),
    //  Color(0xffEF3B36),
        
       Color(0xFF00B7FF), 
        
      Color(0xff00FFEE),
      ],
    ), 
              ),
              height: 300.0,
             // color: Theme.of(context).primaryColor,
            ),
          ),
         Align( 
           alignment: Alignment.topLeft,
           child: 
          Padding(
            padding: EdgeInsets.only(top: 40.0 ),
            child: Row(
            children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.back, size: 35.0,) ,
                onTap: () =>Navigator.pop(context),
              )
             ,
              
              Text("Help", style: TextStyle( color: Colors.white, fontSize:17.0, decoration: TextDecoration.none, fontFamily: "SF"),)
            ],
         ) ,
          )
         ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
               padding: EdgeInsets.only(top: 100.0, left: 20.0),
               child: Text("Contact Us", style: TextStyle( color: Colors.white, decoration: TextDecoration.none, fontFamily: "SF", fontSize: 35.0),),
            )
            
          ),
        Align(
          alignment: Alignment.center,
          child:    Container(
            margin: EdgeInsets.only(top: 85.0),
          height: 200.0,
          child: Column(
            children: <Widget>[
              Icon(Icons.phone, color: Colors.black.withOpacity(0.7),),
              GestureDetector(
                 child:  Text("Phone: 416-786-2641", style: TextStyle( color: Colors.black.withOpacity(0.7), fontFamily: "SF", fontSize: 17.0, decoration: TextDecoration.none),),
                onTap: (){
                  launch("tel://+14167862641");
                },
              ),
             
              SizedBox(height: 40.0,),
              Icon(Icons.email, color: Colors.black.withOpacity(0.7),),
                Text("Email: Support@Ebzie.com", style: TextStyle( color: Colors.black.withOpacity(0.7), fontFamily: "SF", fontSize: 17.0, decoration: TextDecoration.none),),





            ],
          ),
        ),
        )
     

        ],
      ),
    );
  }
}
