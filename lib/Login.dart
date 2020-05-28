import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './mainPage.dart';
import './Register.dart';
import "package:firebase_auth/firebase_auth.dart";
import "./registration/setup.dart";
import 'package:flutter/cupertino.dart';
import './settings/change.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String email;
  FirebaseUser user;
  String password, msgAlert;
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  void _login() async {
    email = _emailController.text;
    password = _passWordController.text;

    if (_emailKey.currentState.validate() &&
        _passwordKey.currentState.validate()) {
      try {
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(user.uid)));
      } catch (e) {
        if (e.toString() ==
            "PlatformException(Error 17009, FIRAuthErrorDomain, The password is invalid or the user does not have a password.)") {
          setState(() {
            msgAlert = "The email or password you have entered is incorrect";
          });
        } else if (e.toString() ==
            "PlatformException(Error 17011, FIRAuthErrorDomain, There is no user record corresponding to this identifier. The user may have been deleted.)") {
          setState(() {
            msgAlert = "There is no account linked to this email";
          });
        }

        setState(() {
          msgAlert = e.toString();
        });
      }
    }
  }

  void _sendUserToMainPage(String uid) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage(uid)));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    if (msgAlert == null) {
      msgAlert = " ";
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Container(
        //margin: EdgeInsets.symmetric(horizontal: 30.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
          // image: DecorationImage( image: AssetImage("assets/setup/login_red.png"), fit: BoxFit.cover)
        ),
        child: Column(
          children: <Widget>[
            //   SizedBox( height: 5.0,),
            //    Align(alignment: Alignment.topLeft, child: IconButton( icon: Icon(CupertinoIcons.back, color: Colors.white,), onPressed: (){
            //   Navigator.pop(context);
            // },), ),
            SizedBox(
              height: 65.0,
            ),
            Text(
              "Ebzie",
              style: TextStyle(
                fontFamily: "SF",
                fontSize: 40.0,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            //  Text("Ebzie",style: TextStyle( fontFamily: "SF",color: Colors.white, fontSize: 35.0, ),textAlign: TextAlign.center,),
            SizedBox(
              height: 100.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Padding( child: Text("Email", style: TextStyle( color: Theme.of(context).primaryColor, fontSize: 18.0, fontFamily: "gotham_medium"), ), padding: EdgeInsets.symmetric( horizontal: 2.0, vertical: 5.0),),
                  Form(
                    key: _emailKey,
                    child: TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                          fontFamily: "SF",
                          color: Colors.white,
                          fontSize: 18.0),
                      decoration: InputDecoration(

                          border: 
                          OutlineInputBorder(

                            borderSide: BorderSide(color: Colors.white)
                          ),
                          //  UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor,) ),
                          // focusedBorder: UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor,) ),
                          //  enabledBorder: UnderlineInputBorder( borderSide: BorderSide( color:Theme.of(context).primaryColor,) ),
                          // disabledBorder:UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor,) ) ,
                          // errorBorder: UnderlineInputBorder( borderSide: BorderSide( color: Colors.red) ),
                          contentPadding: EdgeInsets.only(
                              left: 8.0, top: 15.0, bottom: 15.0),
                          // border: OutlineInputBorder(),
                          // filled: true,
                          //  fillColor: Colors.white.withOpacity(0.4),
                          errorStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          // border: InputBorder.none,

                          hintText: "Email",
                          hintStyle: TextStyle(
                              color: Colors.grey[100], fontFamily: "SF"),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2)

                          //  contentPadding: EdgeInsets.all(5.0),
                          ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please enter a valid email address";
                        } else if (value.replaceAll("\S", "").length == 0) {
                          return "Please enter a valid email address";
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return "Please enter a valid email address";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Padding( child: Text("Password", style: TextStyle( color: Theme.of(context).primaryColor, fontSize: 18.0, fontFamily: "gotham_medium"), ), padding: EdgeInsets.symmetric( horizontal: 2.0, vertical: 5.0),),
                  Form(
                    key: _passwordKey,
                    child: TextFormField(
                      autocorrect: false,
                      obscureText: true,
                      controller: _passWordController,
                      style: TextStyle(
                        fontFamily: "SF",
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(),
                          //UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor,) ),
                          // focusedBorder: UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor, ),),
                          //  enabledBorder: UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor, ),),
                          // disabledBorder:UnderlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor,) ) ,
                          // errorBorder: UnderlineInputBorder( borderSide: BorderSide( color: Colors.red) ),

                          errorStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Theme.of(context).primaryColor),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.grey[100], fontFamily: "SF"),
                          contentPadding: EdgeInsets.only(
                              left: 8.0, top: 15.0, bottom: 15.0),
                          fillColor: Colors.white.withOpacity(0.2)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter your passwrod ";
                        } else if (value.replaceAll("\S", "").length == 0) {
                          return "Please enter your password";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                height: 1.5,
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              SizedBox(
                width: 3.0,
              ),
              GestureDetector(
                child: Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "SF",
                    fontSize: 18.0,
                  ),
                ),
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChangePage())),
              ),
              SizedBox(
                width: 3.0,
              ),
              Container(
                height: 1.5,
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
            ]),
            SizedBox(
              height: 25.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Colors.white),
                //elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                padding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 130.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      //Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: _login,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              msgAlert,
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
              textAlign: TextAlign.center,
            ),

            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: 70.0,
                    child: Center(
                      child: Text(
                        "Dont have an account? Sign Up",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage()));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
