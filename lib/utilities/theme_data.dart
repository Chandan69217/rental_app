import 'package:flutter/material.dart';
import 'package:rental_app/main.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

ThemeData themeData() {
  return ThemeData(
      useMaterial3: true,
      textTheme: TextTheme(
        titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            color: ColorTheme.Blue,
            fontSize: 36.fss),
        titleSmall: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          color: ColorTheme.Gray,
          fontSize: 12.fss
        )
      ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.ss))
    )
  );
}
