import 'package:flutter/material.dart';
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
            fontSize: 30.fss),
        titleSmall: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          color: ColorTheme.Gray,
          fontSize: 12.fss
        ),
        bodyMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 14.fss),
      ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.ss))
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: const BorderSide(
            width: 1.8, color:Colors.black45,
        ),
    )
  );
}
