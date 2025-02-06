import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBoxOptions{
  BuildContext context;
  String? message;
  String heading;
  VoidCallback? onPositive;
  VoidCallback? onNegative;
  String postiveTitle;
  String negativeTitle;
  DialogBoxOptions({
    required this.context,
    this.heading="Warning",
    this.message,
    this.onPositive,
    this.onNegative,
    this.negativeTitle="No",
    this.postiveTitle="Yes"
  }){
    showDialog(context: context,
        builder: (dcontext){
          return WillPopScope(
            onWillPop: (){
              return Future.value(false);
            },
            child: AlertDialog(
              title: Text('$heading'),
              content: Text('$message'),
              actions: [
                TextButton(onPressed:onNegative??(){Navigator.of(dcontext).pop();},
                    child:Text(negativeTitle) ),
                TextButton(onPressed:onPositive,
                    child:Text(postiveTitle) ),
              ],
            ),
          );
        });
  }
}