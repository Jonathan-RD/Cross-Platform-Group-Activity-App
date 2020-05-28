import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PicView extends StatelessWidget {
 final String image;
  PicView(this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              image,
            ),
            fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
          child:GestureDetector(
          child: Container(
            
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              shape: BoxShape.circle),
            child:  Icon(Icons.close, color:Colors.white.withOpacity(0.8), size: 30.0,),
          ),
          
          onTap: ()=>Navigator.pop(context)
        ) ,
        )
        
        
      ),
    );
  }
}
