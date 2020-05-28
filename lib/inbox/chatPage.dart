import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../mainPage.dart';
import '../events/results.dart';
import 'package:flutter/cupertino.dart';
import './ItemBuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'DateComparison.dart';

var _scaffoldContext;

class ChatView extends StatefulWidget {
  final String chatName;
  final String currentUid;
  String refName, firstName;

  ChatView(this.chatName, this.currentUid, this.refName, this.firstName);

  @override
  State<StatefulWidget> createState() {
    return _ChatViewState();
  }
}

class _ChatViewState extends State<ChatView> {
  DatabaseReference convoRef;

  Future<FirebaseUser> user;
  final _inputController = TextEditingController();
  String inputText = "";
  static String convoName;
  String chatName, userImage, convoNickName, firstName;
  
  File sentFile;
  String sentFileLink;
  Map<String, int> colors;

  @override
  void initState() {
    
    convoRef = FirebaseDatabase.instance
        .reference()
        .child("Messages")
        .child(widget.chatName);
    //getUserUid();
    getUserInfo();

    super.initState();
  }

  void displayDropDownMenu() {}

  @override
  Widget build(BuildContext context) {
    print(widget.refName);
    return Scaffold(
      backgroundColor: Color(0xffF5f5f5),
      appBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Padding( padding: EdgeInsets.only( bottom: 3.0,), 
        child: 
        FirebaseAnimatedList(
          query: FirebaseDatabase.instance
                                  .reference()
                                  .child("Convos")
                                  .child(widget.refName)
                                  .child("members"),
           scrollDirection: Axis.horizontal,
           shrinkWrap: true, 
           itemBuilder: (BuildContext context, DataSnapshot picSnapshot, Animation animation, int index) {
              return  CircleAvatar(
                    backgroundColor: Colors.transparent,
                   radius: 23.0,
                   backgroundImage: NetworkImage(picSnapshot.value["pic"],  ));
               
              
           },
           
        ),),
        ],),
       
        transitionBetweenRoutes: true,
        // heroTag: "dfghj",

        //backgroundColor: Theme.of(context).primaryColor,
        trailing: Icon(
          CupertinoIcons.ellipsis,
          color: Theme.of(context).primaryColor,
        ),
        actionsForegroundColor: Theme.of(context).primaryColor,
        previousPageTitle: "Inbox",
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: FirebaseAnimatedList(
                query: convoRef,
                padding: EdgeInsets.all(8.0),
                reverse: true,
                sort: (a, b) => b.key.compareTo(a.key),
                itemBuilder: (context, DataSnapshot messageSnapshot,
                    Animation<double> animation, int a) {
                  return ItemBuilder(
                    widget.currentUid,
                    colors,
                    messageSnapshot: messageSnapshot,
                    animation: animation,
                  );
                },
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              //  decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _textFieldBuilder(),
            ),
            // Builder(builder: (BuildContext contrxt) {
            //   _scaffoldContext = context;
            //   return Container(width: 0.0, height: 0.0);
            // })
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                    top: BorderSide(
                color: Colors.grey[200],
              )))
            : null,
      ),
    );
    //);
  }

  Widget _textFieldBuilder() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
      // color: Color(0xffe5e5e5).withOpacity(0.5),
      // margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          ShaderMask(
              shaderCallback: (reac) {
                return RadialGradient(
                        radius: 1.0,
                        // begin: FractionalOffset.bottomLeft,
                        // end: FractionalOffset.topRight,
                        colors: <Color>[
                          const Color(0xffB066FE),
                          //const Color(0xFF52C3FB),
                          const Color(0xff63E2FF),
                          // const Color(0xffd74177),
                          // const Color(0xffffe98a),
                        ],
                        tileMode: TileMode.repeated)
                    .createShader(reac);
              },
              child: GestureDetector(
                child: Icon(
                  CupertinoIcons.photo_camera_solid,
                  size: 35.0,
                ),
                onTap: showSheet,
              )),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
              child: Container(
            margin: EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colors.grey.withOpacity(0.7))),
            child: TextField(
                maxLines: null,
               
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black.withOpacity(0.7)),
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: "Aa",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  filled: true,
                  fillColor: Theme.of(context).canvasColor,
                ),
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                }),
          )),
          GestureDetector(
            child: Text(
              "Send",
              style: TextStyle(
                  fontFamily: "SF",
                  fontSize: 17.0,
                  color: inputText.replaceAll(' ', "").length > 0
                      ? CupertinoColors.activeBlue
                      : Colors.transparent),
            ),
            onTap: (){
            if (inputText.replaceAll('', "").length > 0 || inputText != null){
            
           String key = convoRef.push().key;
              _sendMsg(inputText, null, key);
            }
           
            
            }
               
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
    );
  }

  
  
 
  
  
  
  
  
  
  
  void _sendMsg(String text, String link, String key) async {
    Map<String, dynamic> msgMap = {
      "userUid": widget.currentUid,
      "imageUrl": link,
      "text": text,
      
      "sender": widget.firstName,
    };

    try {
     
     
      await convoRef.child(key).
      update(msgMap).whenComplete(() {
        _submittedMsg();

        DateTime bleh = DateTime.now();
        String min = TimeOfDay.now().minute.toString();
        String hour = TimeOfDay.now().hour.toString();

        if (min.length == 1){
          min = "0" + min;
        }
        if (hour.length == 1){
          hour = "0" + hour;
        }
        
        String x = hour +
            ":" + min + ":00";
       String y = DateFormat("yyyy-MM-dd").format(bleh).toString();
       

        String dateTime = (y + " " + x);

        FirebaseDatabase.instance
            .reference()
            .child("Convos")
            .child(widget.refName)
            .child("lastmessage")
            .set(inputText);
        FirebaseDatabase.instance
            .reference()
            .child("Convos")
            .child(widget.refName)
            .child("date")
            .set(dateTime);
       
      });
    } catch (e) {
      showAboutDialog(
          context: context,
          applicationName: "Error",
          children: <Widget>[
            Center(
              child: Text(
                e.toString(),
                textAlign: TextAlign.center,
              ),
            )
          ]);
    }
  }

  void _submittedMsg() {
    setState(() {
      _inputController.clear();
    });
  }

  // void getUserUid() async {
  //   FirebaseUser user =  await FirebaseAuth.instance.currentUser();

  //   currentUserUid = user.uid;
  // }
  showSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text("From Camera"),
              onPressed: () {
                // _useCamera();
              },
            ),
            CupertinoActionSheetAction(
              child: Text("From Gallery"),
              onPressed: () {
                _getPicFromGallery();
              },
            )

            //  Text("From Camera"),
            //  Text("From Camera Roll"),
          ],
        );
      },
    );
  }

  void _getPicFromGallery() async {
     
  
                    ImagePicker.pickImage(source: ImageSource.gallery,)
        .then((File image) {
      Navigator.pop(context);
       String key = convoRef.push().key;
      _sendMsg(null,null,key);
      sentFile = image;

      String bleh = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(widget.currentUid + bleh + ".jpg");

      storageReference.putFile(sentFile).onComplete.then((value) {
        value.ref.getDownloadURL().then((onValue) {
         
             sentFileLink = onValue.toString();
              convoRef.child(key).child("imageUrl").set(onValue.toString());
               
          FirebaseDatabase.instance
            .reference()
            .child("Convos")
            .child(widget.refName)
            .child("lastmessage")
            .set(firstName + " sent an image");
         
        });
      });
    });

          
                      
                     // Uri downloadUrl = (await uploadTask.future).downloadUrl;
                      
                    
    
    

   // _sendMsg();
  }

  getUserInfo() async {
    // await FirebaseDatabase.instance
    //     .reference()
    //     .child("Users")
    //     .child(widget.currentUid)
    //     .once()
    //     .then((snapshot) {
    //   firstName = snapshot.value["firstname"].toString();
    //   userImage = snapshot.value["profileimage"].toString();
      FirebaseDatabase.instance
          .reference()
          .child("Convos")
          .child(widget.refName)
          .child("members")
          .child(widget.currentUid)
          .child("pic")
          .set(userImage);
  //  });
  }
}
