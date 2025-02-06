import 'package:flutter/material.dart';

import 'color_theme.dart';


class PrimaryButton extends StatefulWidget {
  VoidCallback? onPressed;
  String title;
  Color buttonColor;
  Color textColor;
  var textStyle;
  EdgeInsets? padding;

  PrimaryButton(
      {required this.title,
        required this.onPressed,
        this.buttonColor = ColorTheme.primaryColor,
        this.textColor = ColorTheme.lightTextColor,
        this.textStyle,
        this.padding = const EdgeInsets.symmetric(vertical: 10),
        Key? key})
      : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // style: ElevatedButton.styleFrom(
      //   primary: widget.buttonColor,
      //   elevation: 0,
      // ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0.0),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return widget.buttonColor;
              else if (states.contains(MaterialState.disabled))
                return Color(0xFFEAEDEF).withOpacity(0.2);
              return widget.buttonColor; // Use the component's default.
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return widget.textColor;
              else if (states.contains(MaterialState.disabled))
                return ColorTheme.primaryTextColor.withOpacity(0.2);
              return widget.textColor; // Use the component's default.
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
              return widget.textStyle != null
                  ? widget.textStyle
                  : Theme.of(context).textTheme.subtitle1;
            },
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: this.widget.padding!,
          child: Text(
            widget.title,
            // style: widget.textStyle != null
            //     ? widget.textStyle.apply(color: widget.textColor)
            //     : Theme.of(context)
            //         .textTheme
            //         .subtitle1
            //         ?.apply(color: widget.textColor),
          ),
        ));
  }
}
