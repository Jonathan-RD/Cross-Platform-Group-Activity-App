import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SelectionModal extends StatelessWidget {
  final Function getPicFromGallery;
  final Function useCamera;
  final Function deletePic;

  SelectionModal(this.getPicFromGallery, this.useCamera, this.deletePic);

  @override
  Widget build(BuildContext context) {
    return Container(
    
        height: 150.0,
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
          
            SizedBox(height: 20.0,),
            ListTile(
               
              //padding: EdgeInsets.symmetric(vertical: 15.0),
              //child: Container( width: MediaQuery.of(context).size.width,
              title:    Text( "From Camera",style: TextStyle( color: Theme.of(context).primaryColorDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
            //  ),
               
              onTap: useCamera,
            ),
           
           ListTile(
             // padding: EdgeInsets.symmetric(vertical: 15.0),
            //  child: Container( width: MediaQuery.of(context).size.width,
              title:  Text( "From Camera Roll",style: TextStyle( color: Theme.of(context).primaryColorDark,
                    ), textAlign: TextAlign.center,
                  ),
                //  ), 
                 
              
              onTap: getPicFromGallery,
            ),
       
             ListTile(
              //padding: EdgeInsets.symmetric(vertical: 15.0),
             
                 
               // child: Container( width: MediaQuery.of(context).size.width,
                title:  Text( "Delete photo",style: TextStyle( color: Colors.redAccent,
                    ), textAlign: TextAlign.center,
               
              ),
              //),
                
              onTap: deletePic,
            ),





          ],
        ));
  }
}