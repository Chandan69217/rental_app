import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
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
          child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 58.ss, right: 58.ss),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/mobile_user_illustration.webp',
                  width: 250.ss,
                  height: 250.ss,
                ),
                Text(
                  'Hello',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Welcome to Hostel Hire Your ultimate  companion for hassle-free hostel bookings!',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 80.ss,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.ss)),
                      ),
                      minimumSize: WidgetStatePropertyAll(Size(180, 40)),
                      backgroundColor: WidgetStatePropertyAll(ColorTheme.Blue),
                      foregroundColor:
                          WidgetStatePropertyAll(ColorTheme.Snow_white),
                      textStyle: WidgetStatePropertyAll(TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold))),
                  child: const Text('Log In'),
                ),
                SizedBox(
                  height: 12.ss,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1.ss, color: ColorTheme.Blue),
                            borderRadius: BorderRadius.circular(10.ss)),
                      ),
                      minimumSize: WidgetStatePropertyAll(Size(180, 40)),
                      foregroundColor: WidgetStatePropertyAll(ColorTheme.Blue),
                      textStyle: WidgetStatePropertyAll(TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold))),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
