import 'package:flutter/material.dart';

class CustomLoader{

  BuildContext? context;
  CustomLoader({this.context}){
    showGeneralDialog(
        context: context!,
        barrierDismissible: false,
        barrierLabel: MaterialLocalizations.of(context!)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Container(
            width: MediaQuery.of(context!).size.width ,
            height: MediaQuery.of(context!).size.height,

            color: Color.fromRGBO(255, 255, 255,.75),
            child: Center(child: CircularProgressIndicator()),

          );
        });
  }

  CustomLoader.close(context){
    Navigator.pop(context);
  }
}
