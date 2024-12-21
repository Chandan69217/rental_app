import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class CustomTextField extends StatelessWidget {
  final bool? obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final bool enable;
  final bool error;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key, required this.keyboardType,
      required this.hintText,
      this.obscureText = false,
      this.enable = true,
      this.controller,
      this.focusNode,
      this.textInputAction,
      this.error = false});
  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(selectionHandleColor: ColorTheme.Blue),
      child: TextField(
        controller: controller,
        enabled: enable,
        focusNode: focusNode,
        textInputAction: textInputAction,
        cursorColor: ColorTheme.Blue,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8.ss, right: 8.ss),
            hintText: hintText,
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: error ? Colors.redAccent:ColorTheme.Gray, width: 2.ss)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: error ? Colors.redAccent:ColorTheme.Gray, width: 2.ss)),
            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: error ? Colors.redAccent:ColorTheme.Gray) ),
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 14.ss, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
