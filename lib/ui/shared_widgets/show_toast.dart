import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class ShowToast{
  BuildContext? context;
  String? message;
  ShowToast(context,message){
    showFlash(
        duration: Duration(seconds:2),
        context:context,
        builder: (context,controller){
          return Flash.dialog(
              controller: controller,
              backgroundColor: Colors.grey[600],
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(5),
              //margin: EdgeInsets.all(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(message,style: TextStyle(color: Colors.white),),
              ));
        }
    );
  }
}