import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/shared_widgets/error_dialog_box.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils.errorDialog(BuildContext context,String? errorMsg,{String heading ="Login Failed", VoidCallback? onPressed}){
    showDialog(context: context, builder:(context){
      return ErrorDialogBox(errorMsg,heading:heading,onPressed: onPressed,);
    });
  }
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static  int compareVersions(String v1, String v2){
    var ver1 = v1.split(".").map(int.parse).toList();
    var ver2 = v2.split(".").map(int.parse).toList();
    var size = max(ver1.length, ver2.length);
    //print(length);
    ver1.addAll(List.filled(size-ver1.length, 0));
    ver2.addAll(List.filled(size-ver2.length, 0));
    print("$ver1 \n $ver2");
    for(int i =0; i<size; i ++){
      print("${ver1[i]} > ${ver2[i]} === > ${ver1[i]>ver2[i]}");
      if(ver1[i]>ver2[i]) return 1;
      else if(ver1[i]<ver2[i]) return -1;
    }
    return 0;
  }
}
