import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';

// ignore: must_be_immutable
class ErrorDialogBox extends StatelessWidget {
  String? errorMsg;
  String heading;
  VoidCallback? onPressed;
  ErrorDialogBox(this.errorMsg,{this.heading ="Login Failed", this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded,size: 50,color: Colors.green,),
            SizedBox(height: 10,),
            Text("$heading",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 20,),
            Text(errorMsg!),
            TextButton(
              
              onPressed:(){
               onPressed == null ? Navigator.of(context).pop():onPressed;
              }, child: Text("Ok"),
            )
          ],
        ),
      ),
    );
  }
}
