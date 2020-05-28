import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FAQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FaqState();
  }
}

class FaqState extends State<FAQ> {
  List<String> questions = [
    "Q: Can I delete my account?",
    "Q: Can I change the email I login with?",
    "Q: How secure is my information?",
    "Q: Can I create a group with a custom event or activity?",
    "Q: Can I temporarily deactivate my account?",
    "Q: Is Ebzie free?",
    "Q: Phone was stolen, what do I do?"
  ];

  List<String> answers = [
    "A: Yes you can find the \"delete my account\" button in the account settings tab",
    "A: Unfortunately, due to security reasons it is not possible to change your login email because all of your user info is linked to it.",
    "A: Ebzie works hard to make sure all your information is safe, we ask for very little of your information and it is never shared with anyone, not even for proft. #NotZuckerberg.",
    "A: For now, Ebzie has created some general events and activities for you to set up groups for, we are currently working on the custom event/activity feature.",
    "A: Unfortunately you cannot temporarily deactivate your account. When deleting your account we scrub our entire database clean of any of your information.",
    "A: Always and forever.",
    "A: Change your password. If you suspect your account was hacked we suggest you contact us and we may be able to sort it out."
  ];

  List<Color> colors = [
    Colors.redAccent,
    Color(0xffFFDE59),
    Color(0xff737373),
    Color(0xffFF914D),
    Color(0xff87CEEB),
    Color(0xffFF66C4),
    Color(0xffFF5757),
  ];

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   middle: Text("FAQ"),
      //   previousPageTitle: "Help",
      //   actionsForegroundColor: Theme.of(context).primaryColor,
      // ),
      child: Scaffold(
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      CupertinoIcons.back,
                      size: 35.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    "Help",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17.0,
                        decoration: TextDecoration.none,
                        fontFamily: "SF"),
                  )
                ],
              ),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
              child: Text(
                "FAQs",
                style: TextStyle(
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none,
                    fontFamily: "SF",
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 50.0),
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              return faqItem(index);
            },
          ),
        ),
      ])),
    );
  }

  Widget faqItem(int index) {
    return Container(
      // color: Theme.of(context).primaryColor,
      child: ExpansionTile(
        title: Text(
          questions[index],
          style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          ListTile(
            title: Text(answers[index]),
          )
        ],
        backgroundColor: colors[index],
      ),
    );
  }
}
