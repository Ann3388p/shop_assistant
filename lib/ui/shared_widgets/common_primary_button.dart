import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommonPrimaryButton extends StatefulWidget {
  VoidCallback? onPressed;
  String? title;
  late Color buttonColor;
  late Color textColor;
  late bool expandButton;
  CommonPrimaryButton({
    this.onPressed,
    this.title,
    this.buttonColor = const Color.fromRGBO(106, 169, 42,1),
    this.textColor = Colors.white,
    this.expandButton = true,
    Key? key}):super(key: key);
  @override
  _CommonPrimaryButtonState createState() => _CommonPrimaryButtonState();
}
class _CommonPrimaryButtonState extends State<CommonPrimaryButton> {
  late bool _buttonIsDisabled ;
  @override
  void initState() {
    _buttonIsDisabled = widget.onPressed!=null?false:true;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width :widget.expandButton ? double.infinity : null,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 15,horizontal: 15)),
          backgroundColor: MaterialStateProperty.all<Color>(_buttonIsDisabled?Colors.grey:widget.buttonColor)
          // padding: EdgeInsets.symmetric(vertical: 15),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // color: Theme.of(context).primaryColor,
        ),
        onPressed: widget.onPressed,

        child: FittedBox(
          child: Text("${widget.title}",style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),),
        ),
      ),
    );
  }
}
