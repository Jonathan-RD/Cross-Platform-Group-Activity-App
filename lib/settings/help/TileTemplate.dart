import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class TileTemplate extends StatelessWidget{
  String title;
  IconData icon;
  Function method;
  BuildContext context1;
  Widget obj;

TileTemplate(this.icon,this.title,this.method, this.context1,this.obj);


  @override
 Widget build(BuildContext context) {
    
    return  Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid)),
          child: ListTile(
            
            enabled: true,
            leading: Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).primaryColor),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: (){
              method(context1, obj);
            },
          ),
        );
  }


}