import 'dart:async';
import '../mainPage.dart';

import 'package:flutter/material.dart';
import '../Login.dart';
import '../registration/pic_modal.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/cupertino.dart';

class SetupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SetupPageState();
  }
}

class _SetupPageState extends State<SetupPage> {
  String firstName,
      surName,
      dob,
      gender,
      status,
      profileImage,
      alertMsg,
      downloadUrl;
  File profileImageFile;
  int day;
  String month;
  int year;

  final _firstNameKey = GlobalKey<FormState>();
  final _surnameKey = GlobalKey<FormState>();
  final _dobKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();
  final dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (alertMsg == null) {
      alertMsg = " ";
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Sign Up",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        leading:
           GestureDetector( child:  Icon(Icons.close), onTap: _sendUserToLogin,),),
      
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  profileImageFile == null
                      ? Image.asset(
                          "assets/default_profile_pic.jpg",
                        )
                      : Image.file(
                          profileImageFile,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: 100.0,
                    left: MediaQuery.of(context).size.width * 0.42,
                    child: FloatingActionButton(
                        child: Icon(
                          Icons.add,
                          size: 25.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        backgroundColor: profileImageFile == null
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        onPressed: () async{
                          
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return _picsModal();
                              });
                        }),
                  ),
                ],
              ),
            ),
            _firstNameForm(),
            _surNameForm(),
            _dob(),
            _genderSpinner(),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              color: Theme.of(context).primaryColorDark,
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              onPressed: _setupUser,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              alertMsg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _setupUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    firstName = firstNameController.text;
    surName = surNameController.text;
    dob = dobController.text;

    if (gender == null) {
      setState(() {
        alertMsg = "Please select your gender";
      });
    }

    if (_firstNameKey.currentState.validate() &&
        _surnameKey.currentState.validate() &&
        _dobKey.currentState.validate()) {
      await profilePicLink(user.uid);

      if (downloadUrl == null) {
        setState(() {
          alertMsg = "Oops... your picture was not uploaded, please try again";
        });
      } else {
        Map<String, dynamic> userInfo = {
          "uid": user.uid,
          "firstname": firstName,
          "surname": surName,
          "dob": dob,
          "gender": gender,
          "profileimage": downloadUrl,
          "status": " ",
          "fullname": firstName + " " + surName
        };

        try {
          await FirebaseDatabase.instance
              .reference()
              .child("Users")
              .child(user.uid)
              .update(userInfo)
              .whenComplete(() {
            _sendUserToLogin;
          });
        } catch (error) {
          setState(() {
            alertMsg = error.toString();
          });
        }
      }
    }
  }

  profilePicLink(String uid) async {
    final Directory systemTempDir = Directory.systemTemp;

    final String rand = uid;
    final StorageReference ref =
        FirebaseStorage.instance.ref().child(rand + ".jpg");

     ref.putFile(profileImageFile).onComplete.then((onValue){
         
         onValue.ref.getDownloadURL().then((value){
         downloadUrl = value.toString();


         });


     });


    

    

    
  }

  void _sendUserToLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void _sendUserToMain() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage("hi")));
  }

  void _getPicFromGallery() {
    ImagePicker
        .pickImage(source: ImageSource.gallery, maxWidth: 500.0)
        .then((File image) {
      Navigator.pop(context);
      setState(() {
        profileImageFile = image;
      });
    });
  }

  void _useCamera() {
    ImagePicker
        .pickImage(source: ImageSource.camera, maxWidth: 500.0)
        .then((File image) {
      Navigator.pop(context);
      setState(() {
        profileImageFile = image;
      });
    });
  }

  Widget _picsModal() {
    return PicModal(_getPicFromGallery, _useCamera);
  }

  Widget _genderSpinner() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 8.0, left: 5.0),
        child: DropdownButton(
          hint: Text("Gender"),
          value: gender,
          items: <String>["Male", "Female", "Other"].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ));
  }

  Widget _firstNameForm() {
    return Form(
      key: _firstNameKey,
      child: TextFormField(
        controller: firstNameController,
        autofocus: false,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(color: Colors.red),
          labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          labelText: "First Name",
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        ),
        validator: (value) {
          if (value.replaceAll(new RegExp('\S'), "").length == 0) {
            return "First name is required";
          }
        },
      ),
    );
  }

  Widget _surNameForm() {
    return Form(
      key: _surnameKey,
      child: TextFormField(
        controller: surNameController,
        autofocus: false,
        style: TextStyle(fontSize: 18.0, color: Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
          errorStyle: TextStyle(color: Colors.red),
          labelStyle: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
          labelText: "Surname",
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        ),
        validator: (value) {
          if (value.replaceAll(new RegExp('\S'), "").length == 0) {
            return "Last name is required";
          }
        },
      ),
    );
  }

  Widget _dob() {
    return Form(
      key: _dobKey,
      child: TextFormField(
        controller: dobController,
        keyboardType: TextInputType.number,
        autofocus: false,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.tealAccent[700]),
          errorStyle: TextStyle(color: Colors.red),
          labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
          labelText: "Date of Birth",
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        ),
        onSaved: (String value) {
          if (value.length == 2 || value.length == 5) {
            value += value + "/";
          }
        },
        validator: (value) {
          if (value.replaceAll(new RegExp('\S'), "").length == 0) {
            return "Birthday is required";
          } else if (value.length < 5) {
            return "Please use the DD/MM/YYYY format";
          }
        },
      ),
    );
  }
}
