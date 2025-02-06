import 'package:flutter/material.dart';


class CustomContainer extends StatelessWidget {
  final Widget? child;
  // final String text;
  final double borderRadius;
  final double padding;
  final double minHeight;
  final double minWidth;
  CustomContainer({
    Key? key,
    required this.child,
    // required this.text,
    this.borderRadius = 10.0,
    this.padding = 16.0,
    this.minHeight = 50.0,
    this.minWidth = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // Scaffold(
      // body: Container(
      //   height: 100,
      //   width: 100,
      decoration: BoxDecoration(
        //boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,

        // border: BorderRadius.all(Radius.circular(20))
      ),
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this.child,
      // child: this.child,
    );
    // );
  }
}