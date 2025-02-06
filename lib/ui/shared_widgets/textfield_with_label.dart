import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? onChanged;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? textColor;
  bool? obscureText;
  final String? hintText;
  final bool readOnly;
  final EdgeInsets? padding;
  final bool  isVisibleMandatory;
  final GestureTapCallback? onTap;
  TextCapitalization ? textCapitalization = TextCapitalization.none;


  TextFieldWithLabel({
    Key? key,
    required this.label,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.autovalidateMode,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.obscureText = false,
    this.onTap,
    required this.isVisibleMandatory,
    this.textCapitalization = TextCapitalization.none,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        children: [
          isVisibleMandatory ? Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),

              child:RichText(
                  text: TextSpan(
                      text: label,
                      style:  Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),

                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize:12.0,
                              fontWeight: FontWeight.bold,
                            )),

                      ])),
            ),
          ): Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            onSaved: onSaved,
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            keyboardType: keyboardType,
            onEditingComplete: onEditingComplete,
            inputFormatters: inputFormatters,
            autovalidateMode: autovalidateMode,
            obscureText: obscureText!,
            readOnly: readOnly,
            textCapitalization: textCapitalization!,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              height: 1.1,
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              suffix: suffixIcon,
              prefix: prefixIcon,
              hoverColor: Colors.white,
              filled: true,
              fillColor: fillColor,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.subtitle1?.apply(
                  heightDelta: 0.5,
                  color: const Color(0xFF061303).withOpacity(0.5)),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(50, 133, 190, 73),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(50, 133, 190, 73),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(50, 133, 190, 73),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          )
        ],
      ),
    );

  }
}