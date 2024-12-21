import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/screens/authentication/login_screen.dart';
import 'package:rental_app/screens/authentication/signup_screen.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:rental_app/widgets/custom_button.dart';
import 'package:sizing/sizing.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32.ss,
                  vertical: 50.ss
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/icons/mobile_user_illustration.webp',
                      width: 250.ss,
                      height: 250.ss,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35.ss),
                      child: Text(
                        'Welcome to Rental App Your ultimate  companion for hassle-free hostel & PG bookings!',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 70.ss,
                    ),
                    CustomButton(
                      onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginScreen())),
                      text: 'Log In',
                      backgroundColor: ColorTheme.Blue,
                      foregroundColor: ColorTheme.Snow_white,
                    ),
                    SizedBox(
                      height: 12.ss,
                    ),
                    CustomButton(text: 'Sign In', onTap: ()=> Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignupScreen())),)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
