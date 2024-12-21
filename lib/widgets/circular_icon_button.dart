
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

class CircularIconButton extends StatelessWidget{
  final String icon;
  final VoidCallback? onTap;
  const CircularIconButton({super.key, required this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(50.ss)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            icon,
            height: 32.ss,
            width: 32.ss,
            fit: BoxFit.cover,
          ),
        ));
  }

}