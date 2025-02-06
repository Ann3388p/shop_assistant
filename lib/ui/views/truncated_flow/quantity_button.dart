import 'package:flutter/material.dart';

class QuantityButton extends StatefulWidget {
  late int quantity;
  late VoidCallback incrementButton;
  late VoidCallback decrementButton;
  QuantityButton(
      {Key? key,
        required this.quantity,
        required this.incrementButton,
        required this.decrementButton})
      : super(key: key);

  @override
  _QuantityButtonState createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 50,
      constraints: BoxConstraints(maxHeight: 30, maxWidth: 90),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.5),
          border: Border.all(
              width: 0.5,
              color:Colors.black,
              style: BorderStyle.solid),
          color: Colors.green[100]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: InkWell(
                onTap: widget.decrementButton, //this.widget.decrementButton,
                child: FittedBox(
                  child: Container(
                    height: 31,
                    width: 31,
                    color: Colors.green[200],
                    child: Center(
                      child: Text(
                        "-",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.apply(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              // SphericalButton(
              //   text: '-',
              //   color: ColorTheme.lightBackground,
              //   onPressed: (){},
              //   key: UniqueKey(),
              // ),
            ),
          ),
          Container(
            child: Text(
              '${this.widget.quantity}',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ClipOval(
            child: InkWell(
                onTap: widget.incrementButton, //this.widget.decrementButton,
                child: FittedBox(
                  child: Container(
                    height: 31,
                    width: 31,
                    color: Colors.green[200],
                    child: Center(
                      child: Text(
                        "+",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.apply(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              // SphericalButton(
              //   text: '-',
              //   color: ColorTheme.lightBackground,
              //   onPressed: (){},
              //   key: UniqueKey(),
              // ),
            ),
          ),
          // GestureDetector(
          //   onTap: this.widget.incrementButton,
          //   child: SphericalButton(
          //     text: '+',
          //     textColor: ColorTheme.lightTextColor,
          //     color: ColorTheme.primaryColor,
          //     onPressed: this.widget.incrementButton,
          //     key: UniqueKey(),
          //   ),
          // ),


        ],
      ),
    );
  }
}