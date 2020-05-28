import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../mainPage.dart';


import 'package:flutter/cupertino.dart';

class ProfilePic extends StatefulWidget {
  Map<String, dynamic> userInfo;
  
  ProfilePic(this.userInfo);
 

  @override
  State<StatefulWidget> createState() {
    return _PicState();
  }
}

class _PicState extends State<ProfilePic> with SingleTickerProviderStateMixin{
  String profileImage;
  String currentUserUid;
  
 
  File profileImageFile;
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    
    getUser();

  controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 2000),
  );
  animation = Tween(begin: 0.0, end: 1.0).animate(controller);




    super.initState();
  }


 getUser() async{

FirebaseUser user = await FirebaseAuth.instance.currentUser();

setState(() {
  currentUserUid = user.uid;
});





 }


 @override
 dispose(){
controller.dispose();
   super.dispose();
 }





 saveInfo() async{

   if ( profileImageFile == null) {

     widget.userInfo.remove("profileimage");
     widget.userInfo["profileimage"] = "https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc";
   }

   else {

     widget.userInfo.remove("profileimage");
     widget.userInfo["profileimage"] = profileImage;




   }

  await FirebaseDatabase.instance.reference().child("Users").child(currentUserUid).update(widget.userInfo).whenComplete((){
    Navigator.pushReplacement(context, CupertinoPageRoute( builder: (BuildContext context)=> MainPage(currentUserUid)));
  });






 }

  @override
  Widget build(BuildContext context) {
   controller.forward();
    return CupertinoPageScaffold(
        
        child: Scaffold(

          body: Container( 
            margin: EdgeInsets.only( top: 0.0),
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
        //      decoration: BoxDecoration( gradient: const LinearGradient(
        //   begin: FractionalOffset.topLeft,
        //   end: FractionalOffset.bottomRight,
        //   tileMode: TileMode.mirror,
        //   colors: <Color>[
        //     Color(0xFF00B7FF),
        //     Color(0xff00FFEE),
        //   ],
        // ),),
          
          
          
          
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              FadeTransition( 
              opacity: animation,
                child: Padding( padding: EdgeInsets.only( left: 20.0, top: 65.0),
              child: Text("PROFILE" +"\n"
                "PICTURE?", textAlign: TextAlign.start, style: TextStyle( fontFamily: "SF", fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.black,),),
              
              
              ),
              ),

              SizedBox( height: 35.0,),
              Container(
              //  color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height * 0.33,
                child: Stack(
                  children: <Widget>[
                    Center(
                    
                      child: CircleAvatar( 
                         radius: 105.0,
                         backgroundColor: Theme.of(context).primaryColor,
                     child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage: profileImageFile == null
                              ? AssetImage(
                                      "assets/default_profile_pic.jpg")
                              : FileImage(profileImageFile)),)
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.40 * 0.60,
                      left: MediaQuery.of(context).size.width * 0.62,
                      child: FloatingActionButton(
                          foregroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: _editPic,
                          //() {

                          // showModalBottomSheet(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return _editPic();
                          //     });
                          // },
                          backgroundColor: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox( height: 50.0,),
               
                Row( 
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                 OutlineButton(
                  borderSide: BorderSide( color: Theme.of(context).primaryColor),
                   padding: EdgeInsets.symmetric( vertical: 15.0, horizontal: 70.0),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
                     color: Colors.white,
                    child: Text(   profileImageFile == null ?"Skip" : "Save", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0, fontFamily: "gotham_medium" ),), onPressed: (){
                      saveInfo();
                  },),

                




                ],)
              
            ],
          ),),
        ));
  }

  void _getPicFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 500.0)
        .then((File image) {
      Navigator.pop(context);
 setState(() {
        profileImageFile = image;
        profileImage = null;
      });


       String bleh =  DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(currentUserUid + bleh + ".jpg");

      storageReference.putFile(profileImageFile).onComplete.then((value) {
        value.ref.getDownloadURL().then((onValue) {
         setState(() {
                    profileImage = onValue.toString();
                  });
        });
      });

     
    });
  }

  void _useCamera() {
    ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 500.0)
        .then((File image) {
      Navigator.pop(context);
       setState(() {
        profileImageFile = image;
        profileImage = null;
      });
 
 
     String bleh =  DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(currentUserUid + bleh + ".jpg");

      storageReference.putFile(profileImageFile).onComplete.then((value) {
        value.ref.getDownloadURL().then((onValue) {
       setState(() {
                profileImage = onValue.toString();
              });
        });
      });

     
    });
  }

  void _deletePic() {
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(currentUserUid)
        .child("profileimage")
        .set(
            "https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc")
        .then((onValue) {
      setState(() {
        profileImage = null;
      });
    });
  }

  // Widget
  _editPic() {
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
          
         
          
          //profileImageFile != null?
           
            // CupertinoActionSheetAction(
            //   isDestructiveAction: true,
            //   child: Text("Delete Picture"),
            //   onPressed: () {
            //     _deletePic();
            //   },
            // ) : null,
            CupertinoActionSheetAction(
              child: Text("From Camera"),
              onPressed: () {
                _useCamera();
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

    // return SelectionModal(_getPicFromGallery, _useCamera, _deletePic);
  }

  // sendBack() async {
  //   if (profileImage == null) {
  //     if (profileImageFile == null) {
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(currentUserUid)
  //           .child("profileimage")
  //           .set(
  //               "https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc");
  //     } else {
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(currentUserUid)
  //           .child("status")
  //           .set(_statusController.text);
  //     }
  //   } else {}

  //   if (profileImage == null) {
  //     if (status2 == widget.status) {
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(widget.currentUserId)
  //           .child("profileimage")
  //           .set(
  //               "https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc");
  //     } else {
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(widget.currentUserId)
  //           .child("profileimage")
  //           .set(
  //               "https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc");
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(widget.currentUserId)
  //           .child("status")
  //           .set(_statusController.text);
  //     }
  //   } else if (profileImage != " ") {
  //     if (status2 != widget.status) {
  //       await FirebaseDatabase.instance
  //           .reference()
  //           .child("Users")
  //           .child(widget.currentUserId)
  //           .child("status")
  //           .set(_statusController.text);
  //     }
  //     if (profileImageFile != null) {
  //       StorageReference storageReference = FirebaseStorage.instance
  //           .ref()
  //           .child(widget.currentUserId + "3" + ".jpg");

  //       storageReference.putFile(profileImageFile).onComplete.then((value) {
  //         value.ref.getDownloadURL().then((onValue) {
  //           FirebaseDatabase.instance
  //               .reference()
  //               .child("Users")
  //               .child(widget.currentUserId)
  //               .child("profileimage")
  //               .set(onValue.toString())
  //               .then((onValue) {
  //             Navigator.pop(context, true);
  //           });
  //         });
  //       });

  //       // storageReference.getDownloadURL().then((onValue) {
  //       //   FirebaseDatabase.instance
  //       //       .reference()
  //       //       .child("Users")
  //       //       .child(widget.currentUserId)
  //       //       .child("profileimage")
  //       //       .set(onValue.toString()).then((onValue){
  //       //         Navigator.pop(context, true);
  //       //       });
  //       // });
  //     }
  //   }
  // }
}
