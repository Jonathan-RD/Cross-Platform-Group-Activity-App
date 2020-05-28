import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Register.dart';
import './Login.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      //backgroundColor: Color(0xfffefffe),
      // appBar: AppBar(
      //   primary: false,
      //   brightness: Theme.of(context).primaryColorBrightness, elevation: 0.0, backgroundColor: Colors.transparent.withOpacity(0.0),),
      body: Container(
        decoration: BoxDecoration(
           
    //        gradient: const LinearGradient(
    //   begin: FractionalOffset.topLeft,
    //   end: FractionalOffset.bottomRight,
     
    //   colors: <Color>[
       
    //     Color(0xFF00B7FF), 
        
    //     Color(0xff00FFEE),
    //     // Color(0xFFff2d55),
    //     // Color(0xfff05053),
    //     //Color(0xffEF3B36),

       
    //   ],
    // ),
   
           
           
           
            image: DecorationImage(
          image: AssetImage("assets/setup/login_red.png"),
          fit: BoxFit.cover,
         )
       ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.33),
            Text(
              "Ebzie",
              style: TextStyle(fontFamily: "gotham_normal", fontSize: 40.0, 
               color: Theme.of(context).primaryColor,
                ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Container(
                child: OutlineButton(
              
              padding: EdgeInsets.symmetric(horizontal: 115.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              child: Text("Login",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).primaryColor,
                    //Colors.white,
                  )),
                   borderSide: BorderSide( color: Theme.of(context).primaryColor,
                 //  Colors.white
                   ),
              color: Colors.white,
              onPressed: ()=> Navigator.push(context, PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                    return LoginPage();




                },
                transitionsBuilder: (context, animation, secondaryAnimation,child){
                   return ScaleTransition(

      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                       CurvedAnimation(
                         parent: animation,
                         curve: Interval(
                           0.00,
                           1.00,
                           curve: Curves.linear
                         ),
                       ),
                     ),
        child:
      ScaleTransition(
          scale: Tween<double>(
                       begin: 1.5,
                       end: 1.0,
                     ).animate(
                       CurvedAnimation(
                         parent: animation,
                         curve: Interval(
                           0.50,
                           1.00,
                           curve: Curves.linear
                         ),
                       ),
                     ),
                     child: child,
                   ),
       );
                }
                 
              ))
              
              
              
              
              
              
              
              
              
              
              // Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (BuildContext context) => LoginPage())),
           
           
           
            )),

             Container(
                margin: EdgeInsets.only( top: 25.0),
                child: RaisedButton(
            elevation: 0.0,
              padding: EdgeInsets.symmetric(horizontal: 103.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              child: Text("Register",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "SF"
                  )),
                 
              color: Theme.of(context).primaryColor,
             // Colors.white,
              
            //  Color(0xff00B7FF),
              onPressed: () =>Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage())),
              
              
            ))
          ],
        ),
      ),
    );
  }
}
