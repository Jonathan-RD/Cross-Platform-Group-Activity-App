import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PicStatus extends StatefulWidget {
  Function setIndex;
  String currentUserId;
  String status;

  Stream<DocumentSnapshot> stream;

  PicStatus(this.stream, this.currentUserId);

  @override
  State<StatefulWidget> createState() {
    return _PicStatusState();
  }
}

class _PicStatusState extends State<PicStatus> {

  TextEditingController _statusController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Users")
          .document(widget.currentUserId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: CupertinoNavigationBar(
            middle: Text(
              "Edit Profile",
            ),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: 5.0, bottom: 15.0, top: 15.0),
                          height: 125.0,
                          width: 125.0,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 62.0,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  NetworkImage(snapshot.data["profileimage"]),
                            ),
                          ),
                        ),
                        GestureDetector(
                            child: Text("Add Photo"), onTap: _editPic)
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 150.0,
                        height: 170.0,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: _editStatus,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15.0),
                            border: InputBorder.none,
                           
                            hintText: snapshot.data["status"],
                          ),
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: CupertinoColors.inactiveGray,
                            width: 0.5,
                            style: BorderStyle.solid))),
              ),
            ],
          ),
        );
      },
    );
  }



/// Method for selecting picture from given source
  void _select(ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 250.0,
      maxHeight: 300.0,
    ).then((File image) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child(widget.currentUserId + DateTime.now().toString() + ".jpg");

      storageReference.putFile(image).onComplete.then((value) {
        value.ref.getDownloadURL().then((onValue) {
          Firestore.instance
              .collection("Users")
              .document(widget.currentUserId)
              .updateData({"profileimage": onValue.toString()});
        });
      });
    });
  }

/// Method for editing status
void _editStatus(String value){
  Firestore.instance.collection("Users").document(widget.currentUserId).updateData({"status": value});
}


/// Method for deleting pic
void _deletePic() {
    Firestore.instance.collection("Users").document(widget.currentUserId).updateData({
      "profileimage":"https://firebasestorage.googleapis.com/v0/b/sqwa-907e4.appspot.com/o/default_profile_pic.jpg?alt=media&token=9f93f02c-1cea-472a-8d32-a9ce6d3e90bc"
    });
}


/// edits pic modal sheet
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
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: Text("Delete Picture"),
              onPressed: () {
                Navigator.pop(context);
                _deletePic();
              },
            ),
            CupertinoActionSheetAction(
              child: Text("From Camera"),
              onPressed: () {
                Navigator.pop(context);
                _select(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text("From Gallery"),
              onPressed: () {
                Navigator.pop(context);
                _select(ImageSource.gallery);
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

  
}
