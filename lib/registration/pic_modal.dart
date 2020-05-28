import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PicModal extends StatelessWidget {
  final Function getPicFromGallery;
  final Function useCamera;

  PicModal(this.getPicFromGallery, this.useCamera);

  @override
  Widget build(BuildContext context) {
    return Container(
      
        height: 200.0,
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              "Show everyone your awesome face!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),
            ),
            SizedBox(height: 20.0,),
            
            OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_enhance,color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text( "From Camera",style: TextStyle( color: Theme.of(context).primaryColorDark,
                    ),
                  )
                ],
              ),
              onPressed: useCamera,
            ),
            SizedBox(height: 10.0,),
            OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.photo_library,color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text( "From Camera Roll",style: TextStyle( color: Theme.of(context).primaryColorDark,
                    ), textAlign: TextAlign.center,
                  )
                ],
              ),
              onPressed: getPicFromGallery,
            ),





          ],
        ));
  }
}
