import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ChangePage extends StatelessWidget {

 FirebaseUser user;
  final inputController = TextEditingController();

 /// Validates email and then sends password reset email
  void _changePassword(BuildContext context)  {
    

    if (inputController.text.isEmpty) {
      _dialog("Please enter your email address", context);
    } else if (inputController.text.replaceAll("\S", "").length == 0) {
      _dialog("Please enter your email address", context);
    } else if (inputController.text != user.email) {
      _dialog("That does not match the email address we have on file", context);
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: inputController.text);
    }
  }

 /// Method to show error message through dialog
  void _dialog(String msg, BuildContext context){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context){
        return CupertinoAlertDialog(  
          title: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Close"),
              onPressed: ()=>Navigator.pop(context),
            )
          ],

        );
      }, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
      
        previousPageTitle: "Settings",
        actionsForegroundColor: Theme.of(context).primaryColor,
        middle: Text(
          "Change Password",
        ),
      ),

      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 200.0,
          ),
          Container(
 
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Theme(
                  data: ThemeData(
                      fontFamily: "SF",
                      hintColor: Colors.grey,
                      primaryColor: Colors.grey),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 20.0),
                      controller: inputController,
                      maxLength: 24,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                style: BorderStyle.solid,
                                width: 2.0)),

                        hintText: "Email",
                        // hintStyle: TextStyle(color: Theme.of(context).primaryColor)
                      ),
                    ),
                  ))),
          SizedBox(
            height: 50.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
              color: Theme.of(context).primaryColor,
              child: Text(
                "Verify",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SF"),
                textAlign: TextAlign.center,
              ),
              onPressed: () => _changePassword(context),
            ),
          ),
         
        
        ],
      ),
    );
    
  }






}


