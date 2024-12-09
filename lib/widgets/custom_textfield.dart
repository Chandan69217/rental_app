import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class CustomTextField extends StatelessWidget {
  final bool? ObscureText;
  final TextInputType keyboardType;
  final String hintText;
  final bool enable;

  CustomTextField(
      {required this.keyboardType,
      required this.hintText,
      this.ObscureText = false,
      this.enable = true,});
  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(selectionHandleColor: ColorTheme.Blue),
      child: TextField(
        enabled: enable,
        cursorColor: ColorTheme.Blue,
        keyboardType: TextInputType.emailAddress,
        obscureText: ObscureText!,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8.ss, right: 8.ss),
            hintText: hintText,
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorTheme.Gray, width: 2.ss)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorTheme.Gray, width: 2.ss)),
            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorTheme.Ghost_White) ),
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 14.ss, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
