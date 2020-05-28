import 'package:intl/intl.dart';

class DateComparison {
  DateTime date;
  

 

  String compare(String date) {
   
   
   this.date = DateTime.parse(date);
   
    DateTime now = DateTime.now();

    String formattedNow = DateFormat("yyyy-MM-dd").format(now).toString();

    String formattedDate =
        DateFormat("yyyy-MM-dd").format(this.date).toString();
    String dateString = this.date.toString();

    if (formattedDate == formattedNow) {
      if(dateString.substring(11) == '0'){
        return date.substring(13, dateString.length-3);
      }
      else{
      return dateString.substring(11, dateString.length - 4);
      }
      
     
    } 
    else {
      if (now.difference(this.date).inDays > 7) {
        return formattedDate.toString();
      } 
      else {
        print(this.date.weekday);
        return this.date.weekday.toString();
      }
    }
  }
}
