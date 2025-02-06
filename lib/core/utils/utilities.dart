import 'package:intl/intl.dart';

class Utilities{


  static convertTimeToString(String textTime){
    DateTime time = DateFormat("HH:mm:ss").parse(textTime);
    String convertedTime = DateFormat("h:mm a").format(time);
    return convertedTime;
  }

  static convertStringToTime(int textTime){


    //  int timestamp = 1680692340000;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(textTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    print("TIME:$formattedTime");
    return formattedTime;// Output: 01:12:14

  }
}