import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

class CustCircularProgress extends StatelessWidget{
  Color? color;
  CustCircularProgress({this.color});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.ss,
      height: 25.ss,
      child: Center(
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }

}