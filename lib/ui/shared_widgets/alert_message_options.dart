import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/ui/shared_widgets/primary_button.dart';

import 'color_theme.dart';




class AlertMessageOptions {
  BuildContext? context;
  String? message;
  String heading;
  VoidCallback? onPositive;
  VoidCallback? onNegative;
  bool enableBackButton;
  AlertMessageOptions({
    required this.context,
    this.heading = "Warning !",
    this.message,
    this.onPositive,
    this.onNegative,
    this.enableBackButton = false
  }) {
    showDialog(
        context: context!,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(enableBackButton);
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              actionsPadding:EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              title: Center(child: Text('$heading',style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold),)),
              content: Text('$message',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w400,color:Colors.black54)),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                PrimaryButton(onPressed: onNegative ??
                        () {
                      Navigator.of(context).pop();
                    },
                  title: "No",
                  buttonColor: ColorTheme.greyColor,
                  textColor: Colors.black54,
                ),
                PrimaryButton(onPressed: onPositive,
                  title: "Yes",
                ),
                // TextButton(
                //   onPressed: onNegative ??
                //       () {
                //         Navigator.of(context).pop();
                //       },
                //   child: Text(
                //     'No',
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline6
                //         ?.copyWith(fontWeight: FontWeight.w600),
                //   ),
                // ),
                // TextButton(
                //   onPressed: onPositive,
                //   child: Text(
                //     'Yes',
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline6
                //         ?.copyWith(fontWeight: FontWeight.w600),
                //   ),
                // ),
              ],

            ),

          );
        });
  }
}
