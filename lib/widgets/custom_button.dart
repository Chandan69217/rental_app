
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../utilities/color_theme.dart';

class CustomButton extends StatelessWidget{
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({super.key, required this.text,required this.onTap,this.backgroundColor,this.foregroundColor = ColorTheme.Blue});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                side:
                BorderSide(width: 1.ss, color: ColorTheme.Blue),
                borderRadius: BorderRadius.circular(10.ss)),
          ),
          minimumSize: WidgetStatePropertyAll(Size(250.ss, 40.ss)),
          backgroundColor:
          WidgetStatePropertyAll(backgroundColor),
          foregroundColor:
          WidgetStatePropertyAll(foregroundColor),
          textStyle: const WidgetStatePropertyAll(TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold))),
      child: Text(text),
    );
  }
}