import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/screens/authentication/welcome_screen.dart';
import 'package:rental_app/utilities/theme_data.dart';
import 'package:sizing/sizing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return SizingBuilder(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        home: const WelcomeScreen(),
      ),
    );
  }
}


