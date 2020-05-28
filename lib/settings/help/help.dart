import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './TileTemplate.dart';
import 'Contact.dart';
import 'FAQ.dart';
import 'package:sqwa/registration/terms.dart';

class Help extends StatelessWidget {
 
 void nav(BuildContext context, Widget obj){

Navigator.push(context, CupertinoPageRoute( builder: (BuildContext context)=>obj));


}
 
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
       backgroundColor: Color(0xffF5F5F7),
      navigationBar: CupertinoNavigationBar(
        actionsForegroundColor: Theme.of(context).primaryColor,
        padding: EdgeInsetsDirectional.only(top: 10.0, end: 15.0),
        middle: Text("Help"),
        previousPageTitle: "Settings",
      ),
      child: Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200.0,
                width: 150.0,
                margin: EdgeInsets.only(top: 100.0, right: 5.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/owl.png"), fit: BoxFit.cover),
                ),
              )
            ],
          ),
          SizedBox(height: 120.0,),
         TileTemplate(Icons.help,"Faq",nav, context, FAQ()),
         TileTemplate(Icons.receipt, "Terms of Service", nav, context, TermsAlert()),
         TileTemplate(Icons.call, "Contact Us", nav, context, Contact()),
          
        ],
      ),)
    );
  }








}
