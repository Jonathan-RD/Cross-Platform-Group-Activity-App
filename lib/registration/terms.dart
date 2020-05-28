import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TermsAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          middle: Text("Terms and Conditions", style: TextStyle( fontFamily: "SF"),),
          leading: Icon(Icons.close, color: Colors.white,),
        ),
        child: 
        ListView(
        
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Don't be a wasteyute",
              textAlign: TextAlign.center,
              style: TextStyle(),
            )
          ],
        ));
  }
}
