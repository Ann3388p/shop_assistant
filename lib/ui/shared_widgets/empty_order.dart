import 'package:flutter/material.dart';

class EmptyOrders extends StatelessWidget {
  final String text;
  const EmptyOrders({this.text = "You don't have any new orders",Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 150,
                  height: 150,
                  child: Image.asset("assets/general/emptyCart.png",fit: BoxFit.contain,)
              ),
              Text(text,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
